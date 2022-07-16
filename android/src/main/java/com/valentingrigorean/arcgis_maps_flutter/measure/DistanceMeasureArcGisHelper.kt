package com.valentingrigorean.arcgis_maps_flutter.measure

import android.annotation.SuppressLint
import android.util.Log
import android.view.MotionEvent
import com.esri.arcgisruntime.geometry.*
import com.esri.arcgisruntime.mapping.view.*
import com.esri.arcgisruntime.symbology.SimpleLineSymbol
import com.esri.arcgisruntime.symbology.SimpleMarkerSymbol

class DistanceMeasureArcGisHelper(
    private val arcMapView: MapView,
) : ArcgisMeasureHelper {
    private var measureMode = MeasureMode.CENTER
    private var measureEnabled = false

    private var canMakePoint = false

    private val srWgs84 = SpatialReferences.getWgs84()
    private val unitOfMeasurement = LinearUnit(LinearUnitId.METERS)
    private val units = "米"
    private val locationMarker =
        SimpleMarkerSymbol(SimpleMarkerSymbol.Style.CIRCLE, 0xFF3700B3.toInt(), 8f)

    private val graphicOverlay = GraphicsOverlay()
    private val startLocation: Graphic = Graphic().apply {
        symbol = locationMarker
    }
    private val endLocation: Graphic = Graphic().apply {
        symbol = locationMarker
    }

    val path = Graphic().apply {
        symbol = SimpleLineSymbol(SimpleLineSymbol.Style.DASH, 0xFF0000FF.toInt(), 5f)
    }
    private val polylinePoints = PointCollection(SpatialReferences.getWgs84())
    private val locationPoints: MutableList<Point> = mutableListOf()
    private val polylineGraphicList: MutableList<Graphic> = mutableListOf()
    private val locationPointGraphicList: MutableList<Graphic> = mutableListOf()

    private val defaultDistanceText = "当前长度: 0 $units"

    private val centerMarker =
        SimpleMarkerSymbol(SimpleMarkerSymbol.Style.CROSS, 0xFF9C27B0.toInt(), 10f)
    private val centerLocationMarker: Graphic = Graphic().apply {
        symbol = centerMarker
    }

    private val viewPointChangedListener: ViewpointChangedListener = ViewpointChangedListener {
        var viewCenterPoint = arcMapView.visibleArea.extent.center
        centerLocationMarker.geometry = viewCenterPoint
        viewCenterPoint = arcMapView.visibleArea.extent.center
        centerLocationMarker.geometry = viewCenterPoint
    }

    override fun setMeasureMode(mode: MeasureMode) {
        measureMode = mode
    }

    override fun makePoint(): Double {
        graphicOverlay.graphics.removeAll(polylineGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)

        val viewCenterPoint = arcMapView.visibleArea.extent.center
        val centerDestination =
            GeometryEngine.project(viewCenterPoint, SpatialReferences.getWgs84())
        return drawPolyline(locationPoints.apply {
            add(viewCenterPoint)
        })
    }

    private fun drawPolyline(points: List<Point>): Double {

        locationPointGraphicList.clear()
        graphicOverlay.graphics.addAll(
            points.map {
                val graphic = Graphic().apply {
                    symbol = locationMarker
                    geometry = GeometryEngine.project(it, SpatialReferences.getWgs84())
                }
                locationPointGraphicList.add(graphic)
                graphic
            }
        )

        val polylineSymbol = SimpleLineSymbol(SimpleLineSymbol.Style.SOLID, 0xFF3700B3.toInt(), 3f)

        if (locationPoints.size > 1) {

            polylinePoints.apply {
                clear()
                addAll(locationPoints)
            }

            val polyline = Polyline(polylinePoints)

            val polylineGraphic = Graphic(polyline, polylineSymbol)
            polylineGraphicList.add(polylineGraphic)
            graphicOverlay.graphics.add(polylineGraphic)

            val pathGeometry = GeometryEngine.densifyGeodetic(
                polyline,
                1.0,
                unitOfMeasurement,
                GeodeticCurveType.GEODESIC
            )
//            path.geometry = pathGeometry

            // calculate path distance
            return GeometryEngine.lengthGeodetic(
                pathGeometry,
                unitOfMeasurement,
                GeodeticCurveType.GEODESIC
            )

        } else {
            return 0.0
        }
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun initMeasure() {
        measureEnabled = true
        arcMapView.graphicsOverlays?.add(graphicOverlay)
        graphicOverlay.graphics.apply {
            add(centerLocationMarker)
//            add(endLocation)
//            add(path)
        }

    }

    override fun revoke(): Double {
        graphicOverlay.graphics.removeAll(polylineGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)
        polylineGraphicList.clear()
        val tmp = locationPoints.removeLastOrNull()
        return if (tmp == null) {
            0.0
        } else {
            return drawPolyline(locationPoints)
        }
    }

    override fun clear(): Double {
        graphicOverlay.graphics.removeAll(polylineGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)
        polylineGraphicList.clear()
        locationPoints.clear()
        return 0.0
    }

    @SuppressLint("ClickableViewAccessibility")
    override fun reset() {
        measureEnabled = false
        startLocation.geometry = null
        endLocation.geometry = null
        path.geometry = null
        arcMapView.callout?.dismiss()
        arcMapView.graphicsOverlays?.remove(graphicOverlay)
        graphicOverlay.graphics.removeAll(polylineGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)
        polylineGraphicList.clear()
        locationPoints.clear()
    }
}

