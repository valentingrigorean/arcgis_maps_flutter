package com.valentingrigorean.arcgis_maps_flutter.workaround

import android.os.Handler
import android.view.Choreographer
import android.view.View

interface FlutterWorkAround {
    val containerView: View
    fun forcePostFrame() {
        Handler().postDelayed({
            Choreographer.getInstance().postFrameCallback {
                containerView.invalidate()
                containerView.requestLayout()
            }
        }, 50)
    }
}