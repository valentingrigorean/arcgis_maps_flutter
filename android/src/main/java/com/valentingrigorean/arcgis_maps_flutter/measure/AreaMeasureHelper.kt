package com.valentingrigorean.arcgis_maps_flutter.measure

import com.esri.arcgisruntime.geometry.*
import com.esri.arcgisruntime.mapping.view.*
import com.esri.arcgisruntime.symbology.SimpleFillSymbol
import com.esri.arcgisruntime.symbology.SimpleLineSymbol
import com.esri.arcgisruntime.symbology.SimpleMarkerSymbol

class AreaMeasureHelper(
    private val arcMapView: MapView,
) : ArcgisMeasureHelper {
    private var measureMode = MeasureMode.CENTER
    private var measureEnabled = false

    private var canMakePoint = false

    private val srWgs84 = SpatialReferences.getWgs84()
    private val unitOfMeasurement = AreaUnit(AreaUnitId.SQUARE_METERS)
    private val unitOfLinear = LinearUnit(LinearUnitId.METERS)
    private val units = "㎡"
    private val locationMarker =
        SimpleMarkerSymbol(SimpleMarkerSymbol.Style.CIRCLE, 0xFF3700B3.toInt(), 8f)

    private val graphicOverlay = GraphicsOverlay()
    private val centerLocation: Graphic = Graphic().apply {
        symbol = locationMarker
    }

    private val path = Graphic().apply {
        symbol = SimpleLineSymbol(SimpleLineSymbol.Style.DASH, 0xFF0000FF.toInt(), 5f)
    }

    private val polygonSymbol =
        SimpleLineSymbol(SimpleLineSymbol.Style.DASH, 0xFF0000FF.toInt(), 5f)
    private val polygonOutlineSymbol =
        SimpleLineSymbol(SimpleLineSymbol.Style.SOLID, 0x7f3700B3, 2f)
    private val polygonFillSymbol =
        SimpleFillSymbol(SimpleFillSymbol.Style.SOLID, 0x7f00FF00, polygonOutlineSymbol)
    private val polygonGeometry = PolygonBuilder(SpatialReferences.getWebMercator())
    private val graphic = Graphic(polygonGeometry.toGeometry(), polygonSymbol)
    private val graphics = graphicOverlay.graphics.apply {
        add(graphic)
    }

    private val allGraphics: MutableList<Graphic> = mutableListOf()
    private val polygonPoints = PointCollection(SpatialReferences.getWgs84())
    private val locationPoints: MutableList<Point> = mutableListOf()
    private val polygonGraphicList: MutableList<Graphic> = mutableListOf()
    private val locationPointGraphicList: MutableList<Graphic> = mutableListOf()

    private val defaultAreaText = "当前面积: 0 $units"

    private val centerMarker =
        SimpleMarkerSymbol(SimpleMarkerSymbol.Style.CROSS, 0xFF9C27B0.toInt(), 10f)
    private val centerLocationMarker: Graphic = Graphic().apply {
        symbol = centerMarker
    }

    private val viewPointChangedListener: ViewpointChangedListener = ViewpointChangedListener {
        if (!measureEnabled){
            return@ViewpointChangedListener
        }
        updateCenterMarker()
    }

    private fun updateCenterMarker(){
        var viewCenterPoint = arcMapView.visibleArea.extent.center
        centerLocationMarker.geometry = viewCenterPoint
        viewCenterPoint = arcMapView.visibleArea.extent.center
        centerLocationMarker.geometry = viewCenterPoint
    }


    override fun makePoint(): Double {
        graphicOverlay.graphics.removeAll(polygonGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)

        val viewCenterPoint = arcMapView.visibleArea.extent.center
        val centerDestination =
            GeometryEngine.project(viewCenterPoint, SpatialReferences.getWgs84())
        return drawPolygon(locationPoints.apply {
            add(viewCenterPoint)
        })
    }

    private fun drawPolygon(points: List<Point>): Double {

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

//        val polylineSymbol = SimpleLineSymbol(SimpleLineSymbol.Style.SOLID, 0xFF3700B3.toInt(), 3f)

        if (locationPoints.size > 1) {

            polygonPoints.apply {
                clear()
                addAll(locationPoints)
            }

            val polygon = Polygon(polygonPoints)

            val polylineGraphic = Graphic(polygon, polygonFillSymbol)
            polygonGraphicList.add(polylineGraphic)
            graphicOverlay.graphics.add(polylineGraphic)

            val pathGeometry = GeometryEngine.densifyGeodetic(
                polygon,
                1.0,
                unitOfLinear,
                GeodeticCurveType.GEODESIC
            )
//            path.geometry = pathGeometry

            // calculate path distance
            return GeometryEngine.areaGeodetic(
                pathGeometry,
                unitOfMeasurement,
                GeodeticCurveType.GEODESIC
            )
        } else {
            return 0.0
        }
    }

    override fun initMeasure() {
        arcMapView.graphicsOverlays?.add(graphicOverlay)
        updateCenterMarker()
        graphicOverlay.graphics.apply {
            add(centerLocationMarker)
        }
        measureEnabled = true
        arcMapView.addViewpointChangedListener(viewPointChangedListener)
    }

    override fun reset() {
        measureEnabled = false
        path.geometry = null
        arcMapView.callout?.dismiss()
        graphicOverlay.graphics.removeAll(polygonGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)
        graphicOverlay.graphics.remove(centerLocationMarker)
        arcMapView.graphicsOverlays?.remove(graphicOverlay)
        polygonGraphicList.clear()
        locationPoints.clear()
        arcMapView.removeViewpointChangedListener(viewPointChangedListener)
    }

    override fun clear(): Double {
        graphicOverlay.graphics.removeAll(polygonGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)
        polygonGraphicList.clear()
        locationPoints.clear()
        return 0.0
    }

    override fun setMeasureMode(mode: MeasureMode) {
    }

    override fun revoke(): Double {

        graphicOverlay.graphics.removeAll(polygonGraphicList)
        graphicOverlay.graphics.removeAll(locationPointGraphicList)
        polygonGraphicList.clear()
        val tmp = locationPoints.removeLastOrNull()
        return if (tmp == null) {
            0.0
        } else {
            drawPolygon(locationPoints)
        }
    }

}