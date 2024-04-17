package com.valentingrigorean.arcgis_maps_flutter.mapping.symbology

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import androidx.core.content.res.ResourcesCompat
import androidx.core.graphics.drawable.DrawableCompat
import com.arcgismaps.mapping.symbology.PictureMarkerSymbol
import com.arcgismaps.mapping.symbology.Symbol
import com.valentingrigorean.arcgis_maps_flutter.convert.toBitmapDrawable

public class SymbolParser {


    public companion object {
        public final fun parseSymbol(context: Context, data: Map<*, *>): Symbol? {
            val type = data["type"] as String
            return when (type) {
                "picture-marker" -> parsePictureMarkerSymbol(context, data)
                else -> null
            }
        }


    }


}

private val resourceIdCache = HashMap<String, Int>()

private fun parsePictureMarkerSymbol(context: Context, data: Map<*, *>): Symbol? {
    var symbol: PictureMarkerSymbol?
    if (data.containsKey("url")) {
        val url = data["url"] as String
        symbol = PictureMarkerSymbol(url)
    }
    if (data.containsKey("resource")) {
        val resource = data["resource"] as String
        val tintColor = data["tintColor"] as Int?
        val drawable = createDrawable(resource, context, tintColor) ?: return null
        symbol = PictureMarkerSymbol.createWithImage(createBitmap(context, drawable))
    }
    if (data.containsKey("imageData")) {
        val bitmap = data["imageData"] as ByteArray
        symbol = PictureMarkerSymbol.createWithImage(bitmap.toBitmapDrawable(context)!!)
    }
    return null
}


fun createBitmap(context: Context, drawable: Drawable): BitmapDrawable {
    if (drawable is BitmapDrawable) {
        return drawable
    }
    val bitmap = Bitmap.createBitmap(
        drawable.intrinsicWidth,
        drawable.intrinsicHeight,
        Bitmap.Config.ARGB_8888
    )
    val canvas = Canvas(bitmap)
    drawable.setBounds(0, 0, canvas.width, canvas.height)
    drawable.draw(canvas)
    return BitmapDrawable(context.resources, bitmap)
}

@SuppressLint("DiscouragedApi")
private fun createDrawable(resourceName: String, context: Context, tintColor: Int?): Drawable? {
    val drawableResourceId: Int
    if (resourceIdCache.containsKey(resourceName)) {
        drawableResourceId = resourceIdCache[resourceName]!!
    } else {
        drawableResourceId =
            context.resources.getIdentifier(resourceName, "drawable", context.packageName)
        resourceIdCache[resourceName] = drawableResourceId
    }
    if (drawableResourceId == 0) {
        return null
    }
    val drawable = ResourcesCompat.getDrawableForDensity(
        context.resources,
        drawableResourceId,
        context.resources.displayMetrics.densityDpi,
        context.theme
    )
    if (tintColor == null) {
        return drawable!!
    }
    val wrappedDrawable = DrawableCompat.wrap(
        drawable!!
    )
    DrawableCompat.setTint(wrappedDrawable, tintColor)
    return wrappedDrawable
}