package com.valentingrigorean.arcgis_maps_flutter.measure

import com.valentingrigorean.arcgis_maps_flutter.workaround.FlutterWorkAround

interface ArcgisMeasureHelper :FlutterWorkAround{
    fun initMeasure()
    fun reset()
    fun clear(): Double
    fun setMeasureMode(mode: MeasureMode)
    fun revoke(): Double
    fun makePoint(): Double
}