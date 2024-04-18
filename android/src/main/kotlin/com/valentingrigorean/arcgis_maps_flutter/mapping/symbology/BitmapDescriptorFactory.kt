package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.annotation.SuppressLint
import android.app.ActivityManager
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.LruCache
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.drawable.DrawableCompat
import com.arcgismaps.Color
import com.arcgismaps.mapping.symbology.CompositeSymbol
import com.arcgismaps.mapping.symbology.PictureMarkerSymbol
import com.arcgismaps.mapping.symbology.SimpleMarkerSymbol
import com.arcgismaps.mapping.symbology.SimpleMarkerSymbolStyle
import com.arcgismaps.mapping.symbology.Symbol
import com.valentingrigorean.arcgis_maps_flutter.convert.fromFlutterColor
import com.valentingrigorean.arcgis_maps_flutter.convert.mapping.symbology.toSimpleMarkerSymbolStyle
import com.valentingrigorean.arcgis_maps_flutter.convert.toArcgisColorOrNull
import com.valentingrigorean.arcgis_maps_flutter.convert.toBitmapDrawable
import com.valentingrigorean.arcgis_maps_flutter.utils.createDrawableBitmap
import com.valentingrigorean.arcgis_maps_flutter.utils.getResourceIdByName
import java.util.Objects

object BitmapDescriptorFactory {

    private var cache: LruCacheEx? = null
    fun fromRawData(context: Context, o: Any?): BitmapDescriptor? {
        val data = o as Map<*, *>? ?: return null
        if (cache == null) {
            createCache(context)
        }
        val fromBytes = data["fromBytes"] as ByteArray?
        if (fromBytes != null) {
            return RawBitmapDescriptor(context, fromBytes)
        }
        val fromAsset = data["fromNativeAsset"]
        if (fromAsset != null) {
            return AssetBitmapDescriptor(context, BitmapDescriptorOptions(data))
        }
        val styleMarker = (data["styleMarker"] as String?)?.toSimpleMarkerSymbolStyle()
        if (styleMarker != null) {
            val color = data["color"]?.toArcgisColorOrNull()!!
            val size = data["size"] as Double
            return StyleMarkerBitmapDescriptor(styleMarker, color, size)
        }
        val descriptors = data["descriptors"] as List<*>?
        if (descriptors != null) {
            val bitmapDescriptors = ArrayList<BitmapDescriptor>()
            for (descriptor in descriptors) {
                val bitmapDescriptor = fromRawData(context, descriptor)
                if (bitmapDescriptor != null) {
                    bitmapDescriptors.add(bitmapDescriptor)
                }
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
        cache = LruCacheEx(limitKb)
    }

    private class RawBitmapDescriptor(context: Context, data: ByteArray) : BitmapDescriptor {
        private val bitmap: BitmapDrawable

        init {
            bitmap = data.toBitmapDrawable(context)!!
        }

        override fun createSymbol(): Symbol {
            return PictureMarkerSymbol.createWithImage(bitmap)
        }
    }

    private class AssetBitmapDescriptor(
        private val context: Context,
        private val bitmapDescriptorOptions: BitmapDescriptorOptions
    ) : BitmapDescriptor {
        override fun createSymbol(): Symbol {
            val cache = cache!!
            if (cache.get(bitmapDescriptorOptions) != null) {
                return cache.get(bitmapDescriptorOptions)!!
            }
            val bitmap = context.createDrawableBitmap(
                bitmapDescriptorOptions.resourceName!!,
                bitmapDescriptorOptions.tintColor
            )
            val symbol =
                bitmap?.let { PictureMarkerSymbol.createWithImage(it) } ?: PictureMarkerSymbol()
            bitmapDescriptorOptions.width?.let {
                symbol.width = it
            }

            bitmapDescriptorOptions.height?.let {
                symbol.height = it
            }

            cache.put(bitmapDescriptorOptions, symbol)
            return symbol
        }

        override fun equals(other: Any?): Boolean {
            if (this === other) return true
            if (other == null || javaClass != other.javaClass) return false
            val that = other as AssetBitmapDescriptor
            return bitmapDescriptorOptions == that.bitmapDescriptorOptions
        }

        override fun hashCode(): Int {
            return Objects.hash(bitmapDescriptorOptions)
        }
    }

    private class CompositeBitmapDescriptor(private val bitmapDescriptors: Collection<BitmapDescriptor>) :
        BitmapDescriptor {
        override fun createSymbol(): Symbol {
            val compositeSymbol = CompositeSymbol()
            for (bitmapDescriptor in bitmapDescriptors) {
                val symbol = bitmapDescriptor.createSymbol()
                compositeSymbol.symbols.add(symbol)
            }
            return compositeSymbol
        }
    }


    private class StyleMarkerBitmapDescriptor(
        private val style: SimpleMarkerSymbolStyle,
        private val color: Color,
        private val size: Double
    ) : BitmapDescriptor {
        override fun createSymbol(): Symbol {
            return SimpleMarkerSymbol(style, color, size.toFloat())
        }

        override fun equals(other: Any?): Boolean {
            if (this === other) return true
            if (other == null || javaClass != other.javaClass) return false
            val that = other as StyleMarkerBitmapDescriptor
            return color == that.color && that.size.compareTo(size) == 0 && style == that.style
        }

        override fun hashCode(): Int {
            return Objects.hash(style, color, size)
        }
    }

    private class BitmapDescriptorOptions(data: Map<*, *>) {
        val resourceName: String?
        var tintColor: Int? = null
        var width: Float? = null
        var height: Float? = null

        init {
            resourceName = data["fromNativeAsset"] as String?
            tintColor = data["tintColor"]?.fromFlutterColor()
            width = (data["width"] as Double?)?.toFloat()
            height = (data["height"] as Double?)?.toFloat()
        }

        override fun equals(other: Any?): Boolean {
            if (this === other) return true
            if (other == null || javaClass != other.javaClass) return false
            val that = other as BitmapDescriptorOptions
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
    }

    private class LruCacheEx
    /**
     * @param maxSize for caches that do not override [.sizeOf], this is
     * the maximum number of entries in the cache. For all other caches,
     * this is the maximum sum of the sizes of the entries in this cache.
     */
        (maxSize: Int) : LruCache<BitmapDescriptorOptions, Symbol>(maxSize) {
        override fun sizeOf(
            key: BitmapDescriptorOptions?,
            value: Symbol
        ): Int {
            return getSymbolSize(value) / 1024
        }

        private fun getSymbolSize(symbol: Symbol): Int {
            return when (symbol) {
                is PictureMarkerSymbol -> symbol.image?.bitmap?.byteCount ?: 4
                is CompositeSymbol -> symbol.symbols.sumOf { getSymbolSize(it) }
                else -> 4
            }
        }
    }
}