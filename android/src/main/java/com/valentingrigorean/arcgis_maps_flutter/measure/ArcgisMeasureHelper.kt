package com.valentingrigorean.arcgis_maps_flutter.measure

interface ArcgisMeasureHelper {
    fun initMeasure()
    fun reset()
    fun clear(): Double
    fun setMeasureMode(mode: MeasureMode)
    fun revoke(): Double
    fun makePoint(): Double
}