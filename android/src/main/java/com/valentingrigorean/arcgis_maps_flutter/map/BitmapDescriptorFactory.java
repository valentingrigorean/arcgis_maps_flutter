package com.valentingrigorean.arcgis_maps_flutter.map;

import android.app.ActivityManager;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.VectorDrawable;
import android.util.Log;
import android.util.LruCache;

import androidx.core.content.res.ResourcesCompat;
import androidx.core.graphics.drawable.DrawableCompat;

import com.esri.arcgisruntime.concurrent.ListenableFuture;
import com.esri.arcgisruntime.symbology.CompositeSymbol;
import com.esri.arcgisruntime.symbology.PictureMarkerSymbol;
import com.esri.arcgisruntime.symbology.SimpleMarkerSymbol;
import com.esri.arcgisruntime.symbology.Symbol;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutionException;
import java.util.stream.Collectors;

import static com.valentingrigorean.arcgis_maps_flutter.Convert.toBitmap;

public class BitmapDescriptorFactory {
    private static LruCacheEx _cache;

    private BitmapDescriptorFactory() {

    }

    public static BitmapDescriptor fromRawData(Context context, Object o) {
        final Map<?, ?> data = (Map<?, ?>) o;
        if (data == null) {
            return null;
        }
        if (_cache == null) {
            createCache(context);
        }

        final Object fromBytes = data.get("fromBytes");
        if (fromBytes != null) {
            return new RawBitmapDescriptor(context, fromBytes);
        }

        final Object fromAsset = data.get("fromNativeAsset");
        if (fromAsset != null) {
            return new AssetBitmapDescriptor(context, new BitmapDescriptorOptions(data));
        }

        final Object styleMarker = data.get("styleMarker");
        if (styleMarker != null) {
            final int color = Convert.toInt(data.get("color"));
            final float size = Convert.toFloat(data.get("size"));
            final SimpleMarkerSymbol.Style style = Convert.toSimpleMarkerSymbolStyle(Convert.toInt(styleMarker));
            return new StyleMarkerBitmapDescriptor(style, color, size);
        }

        final List<Objects> descriptors = (List<Objects>) data.get("descriptors");
        if (descriptors != null) {
            final ArrayList<BitmapDescriptor> bitmapDescriptors = new ArrayList<>();
            for (Object descriptor : descriptors) {
                bitmapDescriptors.add(fromRawData(context, descriptor));
            }
            return new CompositeBitmapDescriptor(bitmapDescriptors);
        }

        return null;
    }

    private static void createCache(Context context) {
        ActivityManager am = (ActivityManager) context.getSystemService(
                Context.ACTIVITY_SERVICE);
        int maxKb = am.getMemoryClass() * 1024;
        int limitKb = maxKb / 8; // 1/8th of total ram
        _cache = new LruCacheEx(limitKb);
    }

    private static class RawBitmapDescriptor implements BitmapDescriptor {
        private BitmapDrawable bitmap;

        public RawBitmapDescriptor(Context context, Object data) {
            bitmap = new BitmapDrawable(context.getResources(), toBitmap(data));
        }


        @Override
        public void createSymbolAsync(BitmapDescriptorListener loader) {
            final ListenableFuture<PictureMarkerSymbol> future = PictureMarkerSymbol.createAsync(bitmap);
            future.addDoneListener(() -> {
                try {
                    loader.onLoaded(future.get());
                } catch (ExecutionException e) {
                    e.printStackTrace();
                    loader.onFailed();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    loader.onFailed();
                }
            });
        }
    }

    private static class AssetBitmapDescriptor implements BitmapDescriptor {

        private static final String TAG = "AssetBitmapDescriptor";

        final Context context;
        final BitmapDescriptorOptions bitmapDescriptorOptions;

        private AssetBitmapDescriptor(Context context, BitmapDescriptorOptions bitmapDescriptorOptions) {
            this.context = context;
            this.bitmapDescriptorOptions = bitmapDescriptorOptions;
        }

        @Override
        public void createSymbolAsync(BitmapDescriptorListener loader) {
            Bitmap bitmap = _cache.get(bitmapDescriptorOptions);
            if (bitmap == null) {
                bitmap = bitmapDescriptorOptions.createBitmap(context);
                _cache.put(bitmapDescriptorOptions, bitmap);
               Log.d(TAG, "createSymbolAsync: Insert bitmap to cache for " + bitmapDescriptorOptions.toString() + ".");
            }
            final ListenableFuture<PictureMarkerSymbol> future = PictureMarkerSymbol.createAsync(new BitmapDrawable(context.getResources(), bitmap));
            future.addDoneListener(() -> {
                try {
                    final PictureMarkerSymbol symbol = future.get();
                    if (bitmapDescriptorOptions.getWidth() != null) {
                        symbol.setWidth(bitmapDescriptorOptions.getWidth());
                    }
                    if (bitmapDescriptorOptions.getHeight() != null) {
                        symbol.setHeight(bitmapDescriptorOptions.getHeight());
                    }
                    loader.onLoaded(symbol);
                } catch (Exception e) {
                    e.printStackTrace();
                    loader.onFailed();
                }
            });
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            AssetBitmapDescriptor that = (AssetBitmapDescriptor) o;
            return Objects.equals(bitmapDescriptorOptions, that.bitmapDescriptorOptions);
        }

        @Override
        public int hashCode() {
            return Objects.hash(bitmapDescriptorOptions);
        }
    }

    private static class CompositeBitmapDescriptor implements BitmapDescriptor {

        private final Collection<BitmapDescriptor> bitmapDescriptors;


        private CompositeBitmapDescriptor(Collection<BitmapDescriptor> bitmapDescriptors) {
            this.bitmapDescriptors = bitmapDescriptors;
        }

        @Override
        public void createSymbolAsync(BitmapDescriptorListener loader) {
            final CompositeBitmapDescriptorListener compositeBitmapDescriptorListener = new CompositeBitmapDescriptorListener(bitmapDescriptors, loader);
            compositeBitmapDescriptorListener.startAsync();
        }
    }

    private static class CompositeBitmapDescriptorListener {
        private final ArrayList<Symbol> symbols = new ArrayList<>();

        private final Collection<BitmapDescriptor> bitmapDescriptors;
        private final BitmapDescriptor.BitmapDescriptorListener listener;

        private int currentSymbols = 0;

        private CompositeBitmapDescriptorListener(Collection<BitmapDescriptor> bitmapDescriptors, BitmapDescriptor.BitmapDescriptorListener listener) {
            this.bitmapDescriptors = bitmapDescriptors;
            this.listener = listener;
            for (int i = 0; i < bitmapDescriptors.size(); i++) {
                symbols.add(null);
            }

        }

        public void startAsync() {
            int i = 0;


            for (BitmapDescriptor bitmapDescriptor : bitmapDescriptors) {
                final int index = i;
                bitmapDescriptor.createSymbolAsync(new BitmapDescriptor.BitmapDescriptorListener() {
                    @Override
                    public void onLoaded(Symbol symbol) {
                        symbols.add(index, symbol);
                        currentSymbols++;
                        checkIfFinish();
                    }

                    @Override
                    public void onFailed() {
                        currentSymbols++;
                        checkIfFinish();
                    }
                });
                i++;
            }
        }


        private void checkIfFinish() {
            if (currentSymbols != bitmapDescriptors.size()) {
                return;
            }
            if (symbols.size() == 0 && bitmapDescriptors.size() > 0) {
                listener.onFailed();
                return;
            }
            final CompositeSymbol symbol = new CompositeSymbol(symbols.stream().filter(e -> e != null).collect(Collectors.toList()));
            listener.onLoaded(symbol);
        }
    }

    private static class StyleMarkerBitmapDescriptor implements BitmapDescriptor {

        private final SimpleMarkerSymbol.Style style;
        private final int color;
        private final float size;

        private StyleMarkerBitmapDescriptor(SimpleMarkerSymbol.Style style, int color, float size) {
            this.style = style;
            this.color = color;
            this.size = size;
        }

        @Override
        public void createSymbolAsync(BitmapDescriptorListener loader) {
            loader.onLoaded(new SimpleMarkerSymbol(style, color, size));
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            StyleMarkerBitmapDescriptor that = (StyleMarkerBitmapDescriptor) o;
            return color == that.color &&
                    Float.compare(that.size, size) == 0 &&
                    style == that.style;
        }

        @Override
        public int hashCode() {
            return Objects.hash(style, color, size);
        }
    }

    private static class BitmapDescriptorOptions {
        private final String resourceName;
        private final Integer tintColor;
        private final Float width;
        private final Float height;


        public BitmapDescriptorOptions(Map<?, ?> data) {
            resourceName = (String) data.get("fromNativeAsset");
            final Object rawTintColor = data.get("tintColor");
            if (rawTintColor != null) {
                tintColor = Convert.toInt(rawTintColor);
            } else {
                tintColor = null;
            }
            final Object rawWidth = data.get("width");
            if (rawWidth != null) {
                width = Convert.toFloat(rawWidth);
            } else {
                width = null;
            }
            final Object rawHeight = data.get("height");
            if (rawHeight != null) {
                height = Convert.toFloat(rawHeight);
            } else {
                height = null;
            }
        }

        public Bitmap createBitmap(Context context) {
            final Drawable drawable = createDrawable(context);
            if (drawable instanceof BitmapDrawable) {
                return ((BitmapDrawable) drawable).getBitmap();
            }

            final Bitmap bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);

            Canvas canvas = new Canvas(bitmap);
            drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
            drawable.draw(canvas);

            return bitmap;
        }

        private Drawable createDrawable(Context context) {
            final int drawableResourceId = context.getResources().getIdentifier(resourceName, "drawable", context.getPackageName());
            final Drawable drawable = ResourcesCompat.getDrawable(context.getResources(), drawableResourceId, context.getTheme());

            if (tintColor == null) {
                return drawable;
            }
            Drawable wrappedDrawable = DrawableCompat.wrap(drawable);
            DrawableCompat.setTint(wrappedDrawable, tintColor);
            return wrappedDrawable;
        }

        public Float getWidth() {
            return width;
        }

        public Float getHeight() {
            return height;
        }

        @Override
        public boolean equals(Object o) {
            if (this == o) return true;
            if (o == null || getClass() != o.getClass()) return false;
            BitmapDescriptorOptions that = (BitmapDescriptorOptions) o;
            return Objects.equals(resourceName, that.resourceName) &&
                    Objects.equals(tintColor, that.tintColor) &&
                    Objects.equals(width, that.width) &&
                    Objects.equals(height, that.height);
        }

        @Override
        public int hashCode() {
            return Objects.hash(resourceName, tintColor, width, height);
        }

        @Override
        public String toString() {
            return "BitmapDescriptorOptions{" +
                    "resourceName='" + resourceName + '\'' +
                    ", tintColor=" + tintColor +
                    ", width=" + width +
                    ", height=" + height +
                    '}';
        }
    }

    private static class LruCacheEx extends LruCache<BitmapDescriptorOptions, Bitmap> {

        /**
         * @param maxSize for caches that do not override {@link #sizeOf}, this is
         *                the maximum number of entries in the cache. For all other caches,
         *                this is the maximum sum of the sizes of the entries in this cache.
         */
        public LruCacheEx(int maxSize) {
            super(maxSize);
        }

        @Override
        protected int sizeOf(BitmapDescriptorOptions key, Bitmap value) {
            return value.getByteCount() / 1024;
        }
    }
}
