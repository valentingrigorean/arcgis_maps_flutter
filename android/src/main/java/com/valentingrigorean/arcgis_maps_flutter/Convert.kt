package com.valentingrigorean.arcgis_maps_flutter

import android.content.Context
import android.util.DisplayMetrics
import android.util.TypedValue

open class Convert {
    companion object {



        fun dpToPixelsI(context: Context, dp: Int): Int {
            return (dp * (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
        }

        fun dpToPixelsF(context: Context, dp: Float): Float {
            return dp * (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)
        }

        fun pixelsToDpI(context: Context, pixels: Float): Int {
            return (pixels / (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)).toInt()
        }

        fun pixelsToDpF(context: Context, pixels: Float): Float {
            return pixels / (context.resources.displayMetrics.densityDpi.toFloat() / DisplayMetrics.DENSITY_DEFAULT)
        }

        fun spToPixels(context: Context, sp: Int): Int {
            return TypedValue.applyDimension(
                TypedValue.COMPLEX_UNIT_SP,
                sp.toFloat(),
                context.resources.displayMetrics
            ).toInt()
        }
    }
}