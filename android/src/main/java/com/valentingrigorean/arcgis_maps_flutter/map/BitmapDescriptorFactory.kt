package com.valentingrigorean.arcgis_maps_flutter.map

import android.app.ActivityManager
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Log
import android.util.LruCache
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.drawable.DrawableCompat
import com.esri.arcgisruntime.concurrent.ListenableFuture
import com.esri.arcgisruntime.internal.jni.CoreImage
import com.esri.arcgisruntime.internal.jni.CorePictureMarkerSymbol
import com.esri.arcgisruntime.symbology.CompositeSymbol
import com.esri.arcgisruntime.symbology.PictureMarkerSymbol
import com.esri.arcgisruntime.symbology.SimpleMarkerSymbol
import com.esri.arcgisruntime.symbology.Symbol
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.map.BitmapDescriptor.BitmapDescriptorListener
import java.util.Objects
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.ExecutionException
import java.util.stream.Collectors

object BitmapDescriptorFactory {
    private val _bitmapDescriptorFutures =
        ConcurrentHashMap<BitmapDescriptorOptions, ListenableFuture<PictureMarkerSymbol>>()
    private var _cache: LruCacheEx? = null
    fun fromRawData(context: Context?, o: Any?): BitmapDescriptor? {
        val data = o as Map<*, *>? ?: return null
        if (_cache == null) {
            createCache(context)
        }
        val fromBytes = data["fromBytes"]
        if (fromBytes != null) {
            return RawBitmapDescriptor(context, fromBytes)
        }
        val fromAsset = data["fromNativeAsset"]
        if (fromAsset != null) {
            return AssetBitmapDescriptor(context, BitmapDescriptorOptions(context, data))
        }
        val styleMarker = data["styleMarker"]
        if (styleMarker != null) {
            val color: Int = Convert.Companion.toInt(
                data["color"]
            )
            val size: Float = Convert.Companion.toFloat(
                data["size"]
            )
            val style: SimpleMarkerSymbol.Style = Convert.Companion.toSimpleMarkerSymbolStyle(
                Convert.Companion.toInt(styleMarker)
            )
            return StyleMarkerBitmapDescriptor(style, color, size)
        }
        val descriptors = data["descriptors"] as List<Objects>?
        if (descriptors != null) {
            val bitmapDescriptors = ArrayList<BitmapDescriptor?>()
            for (descriptor in descriptors) {
                bitmapDescriptors.add(fromRawData(context, descriptor))
            }
            return CompositeBitmapDescriptor(bitmapDescriptors)
        }
        return null
    }

    private fun createCache(context: Context?) {
        val am = context!!.getSystemService(
            Context.ACTIVITY_SERVICE
        ) as ActivityManager
        val maxKb = am.memoryClass * 1024
        val limitKb = maxKb / 8 // 1/8th of total ram
        _cache = LruCacheEx(limitKb)
    }

    private class RawBitmapDescriptor(context: Context?, data: Any) : BitmapDescriptor {
        private val bitmap: BitmapDrawable

        init {
            bitmap = BitmapDrawable(context!!.resources, Convert.Companion.toBitmap(data))
        }

        override fun createSymbolAsync(loader: BitmapDescriptorListener) {
            val future = PictureMarkerSymbol.createAsync(bitmap)
            future.addDoneListener {
                try {
                    loader.onLoaded(future.get())
                } catch (e: ExecutionException) {
                    e.printStackTrace()
                    loader.onFailed()
                } catch (e: InterruptedException) {
                    e.printStackTrace()
                    loader.onFailed()
                }
            }
        }
    }

    private class AssetBitmapDescriptor(
        val context: Context?,
        val bitmapDescriptorOptions: BitmapDescriptorOptions
    ) : BitmapDescriptor {
        override fun createSymbolAsync(loader: BitmapDescriptorListener) {
            val markerSymbolInfo = _cache!![bitmapDescriptorOptions]
            if (markerSymbolInfo != null) {
                loader.onLoaded(markerSymbolInfo.createSymbol())
                return
            }
            if (!_bitmapDescriptorFutures.containsKey(bitmapDescriptorOptions)) {
                val bitmap = bitmapDescriptorOptions.createBitmap(context)
                _bitmapDescriptorFutures[bitmapDescriptorOptions] = PictureMarkerSymbol.createAsync(
                    BitmapDrawable(
                        context!!.resources, bitmap
                    )
                )
            }
            val future = _bitmapDescriptorFutures[bitmapDescriptorOptions]!!
            future.addDoneListener {
                try {
                    val symbol = future.get()
                    val bitmap = symbol.image.bitmap
                    if (bitmapDescriptorOptions.getWidth() != null) {
                        symbol.width = bitmapDescriptorOptions.getWidth()
                    }
                    if (bitmapDescriptorOptions.getHeight() != null) {
                        symbol.height = bitmapDescriptorOptions.getHeight()
                    }
                    val corePictureMarkerSymbol = symbol.internal as CorePictureMarkerSymbol
                    val info = CorePictureMarkerSymbolInfo(
                        bitmap.byteCount,
                        corePictureMarkerSymbol.w(),
                        bitmapDescriptorOptions
                    )
                    _cache!!.put(bitmapDescriptorOptions, info)
                    Log.d(
                        TAG,
                        "createSymbolAsync: Insert bitmap to cache for $bitmapDescriptorOptions."
                    )
                    loader.onLoaded(symbol)
                } catch (e: Exception) {
                    e.printStackTrace()
                    loader.onFailed()
                } finally {
                    _bitmapDescriptorFutures.remove(bitmapDescriptorOptions)
                }
            }
        }

        override fun equals(o: Any?): Boolean {
            if (this === o) return true
            if (o == null || javaClass != o.javaClass) return false
            val that = o as AssetBitmapDescriptor
            return bitmapDescriptorOptions == that.bitmapDescriptorOptions
        }

        override fun hashCode(): Int {
            return Objects.hash(bitmapDescriptorOptions)
        }

        companion object {
            private const val TAG = "AssetBitmapDescriptor"
        }
    }

    private class CompositeBitmapDescriptor(private val bitmapDescriptors: Collection<BitmapDescriptor?>) :
        BitmapDescriptor {
        override fun createSymbolAsync(loader: BitmapDescriptorListener) {
            val compositeBitmapDescriptorListener =
                CompositeBitmapDescriptorListener(bitmapDescriptors, loader)
            compositeBitmapDescriptorListener.startAsync()
        }
    }

    private class CompositeBitmapDescriptorListener(
        private val bitmapDescriptors: Collection<BitmapDescriptor?>,
        private val listener: BitmapDescriptorListener
    ) {
        private val symbols = ArrayList<Symbol?>()
        private var currentSymbols = 0

        init {
            for (i in bitmapDescriptors.indices) {
                symbols.add(null)
            }
        }

        fun startAsync() {
            var i = 0
            for (bitmapDescriptor in bitmapDescriptors) {
                val index = i
                bitmapDescriptor!!.createSymbolAsync(object : BitmapDescriptorListener {
                    override fun onLoaded(symbol: Symbol) {
                        symbols.add(index, symbol)
                        currentSymbols++
                        checkIfFinish()
                    }

                    override fun onFailed() {
                        currentSymbols++
                        checkIfFinish()
                    }
                })
                i++
            }
        }

        private fun checkIfFinish() {
            if (currentSymbols != bitmapDescriptors.size) {
                return
            }
            if (symbols.size == 0 && bitmapDescriptors.size > 0) {
                listener.onFailed()
                return
            }
            val symbol = CompositeSymbol(symbols.stream().filter { e: Symbol? -> e != null }
                .collect(Collectors.toList()))
            listener.onLoaded(symbol)
        }
    }

    private class StyleMarkerBitmapDescriptor(
        private val style: SimpleMarkerSymbol.Style,
        private val color: Int,
        private val size: Float
    ) : BitmapDescriptor {
        override fun createSymbolAsync(loader: BitmapDescriptorListener) {
            loader.onLoaded(SimpleMarkerSymbol(style, color, size))
        }

        override fun equals(o: Any?): Boolean {
            if (this === o) return true
            if (o == null || javaClass != o.javaClass) return false
            val that = o as StyleMarkerBitmapDescriptor
            return color == that.color && java.lang.Float.compare(
                that.size,
                size
            ) == 0 && style == that.style
        }

        override fun hashCode(): Int {
            return Objects.hash(style, color, size)
        }
    }

    private class BitmapDescriptorOptions(context: Context?, data: Map<*, *>) {
        private val resourceName: String?
        private var tintColor: Int? = null
        var width: Float? = null
        var height: Float? = null

        init {
            resourceName = data["fromNativeAsset"] as String?
            val rawTintColor = data["tintColor"]
            tintColor = if (rawTintColor != null) {
                Convert.Companion.toInt(rawTintColor)
            } else {
                null
            }
            val rawWidth = data["width"]
            width = if (rawWidth != null) {
                Convert.Companion.toFloat(rawWidth)
            } else {
                null
            }
            val rawHeight = data["height"]
            height = if (rawHeight != null) {
                Convert.Companion.toFloat(rawHeight)
            } else {
                null
            }
        }

        fun createBitmap(context: Context?): Bitmap {
            val drawable = createDrawable(context)
            if (drawable is BitmapDrawable) {
                return drawable.bitmap
            }
            val bitmap = Bitmap.createBitmap(
                drawable!!.intrinsicWidth,
                drawable.intrinsicHeight,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            return bitmap
        }

        private fun createDrawable(context: Context?): Drawable? {
            var drawableResourceId = 0
            if (_resourceIdCache.containsKey(resourceName)) {
                drawableResourceId = _resourceIdCache[resourceName]!!
            } else {
                drawableResourceId =
                    context!!.resources.getIdentifier(resourceName, "drawable", context.packageName)
                _resourceIdCache[resourceName] = drawableResourceId
            }
            val drawable = ResourcesCompat.getDrawableForDensity(
                context!!.resources,
                drawableResourceId,
                context.resources.displayMetrics.densityDpi,
                context.theme
            )
            if (tintColor == null) {
                return drawable
            }
            val wrappedDrawable = DrawableCompat.wrap(
                drawable!!
            )
            DrawableCompat.setTint(wrappedDrawable, tintColor)
            return wrappedDrawable
        }

        override fun equals(o: Any?): Boolean {
            if (this === o) return true
            if (o == null || javaClass != o.javaClass) return false
            val that = o as BitmapDescriptorOptions
            return resourceName == that.resourceName && tintColor == that.tintColor && width == that.width && height == that.height
        }

        override fun hashCode(): Int {
            return Objects.hash(resourceName, tintColor, width, height)
        }

        override fun toString(): String {
            return "BitmapDescriptorOptions{" +
                    "resourceName='" + resourceName + '\'' +
                    ", tintColor=" + tintColor +
                    ", width=" + width +
                    ", height=" + height +
                    '}'
        }

        companion object {
            private val _resourceIdCache: MutableMap<String?, Int> = HashMap()
        }
    }

    private class LruCacheEx
    /**
     * @param maxSize for caches that do not override [.sizeOf], this is
     * the maximum number of entries in the cache. For all other caches,
     * this is the maximum sum of the sizes of the entries in this cache.
     */
        (maxSize: Int) : LruCache<BitmapDescriptorOptions?, CorePictureMarkerSymbolInfo>(maxSize) {
        override fun sizeOf(
            key: BitmapDescriptorOptions?,
            value: CorePictureMarkerSymbolInfo
        ): Int {
            return value.getSize() / 1024
        }
    }

    private class CorePictureMarkerSymbolInfo(
        val size: Int,
        val coreImage: CoreImage,
        val bitmapDescriptorOptions: BitmapDescriptorOptions
    ) {
        fun createSymbol(): Symbol {
            val symbol = PictureMarkerSymbol.createFromInternal(CorePictureMarkerSymbol(coreImage))
            if (bitmapDescriptorOptions.getWidth() != null) {
                symbol.width = bitmapDescriptorOptions.getWidth()
            }
            if (bitmapDescriptorOptions.getHeight() != null) {
                symbol.height = bitmapDescriptorOptions.getHeight()
            }
            return symbol
        }
    }
}