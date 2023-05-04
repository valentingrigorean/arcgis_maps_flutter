package com.valentingrigorean.arcgis_maps_flutter.convert

import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import java.io.ByteArrayOutputStream

fun BitmapDrawable.toFlutterValue():Any{
    val byteArrayOutputStream = ByteArrayOutputStream()
    bitmap.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)

    return byteArrayOutputStream.toByteArray()
}