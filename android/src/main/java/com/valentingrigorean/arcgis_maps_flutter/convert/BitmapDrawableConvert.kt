package com.valentingrigorean.arcgis_maps_flutter.convert

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import java.io.ByteArrayOutputStream

fun BitmapDrawable.toFlutterValue(): Any {
    val byteArrayOutputStream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)

    return byteArrayOutputStream.toByteArray()
}

fun ByteArray.toBitmapDrawable(context: Context? = null): BitmapDrawable? {
    val bitmap = BitmapFactory.decodeByteArray(this, 0, this.size)
    return BitmapDrawable(context?.resources, bitmap)
}