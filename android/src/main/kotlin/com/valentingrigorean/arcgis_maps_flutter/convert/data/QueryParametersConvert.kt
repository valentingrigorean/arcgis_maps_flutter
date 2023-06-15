package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.QueryParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull

fun Any.toQueryParametersOrNull() : QueryParameters?{
    val data = this as? Map<*, *> ?: return null
    return QueryParameters().apply {
        returnGeometry = data["isReturnGeometry"] as Boolean
        geometry = data["geometry"]?.toGeometryOrNull()
        maxFeatures = data["maxFeatures"] as Int
        whereClause = data["whereClause"] as String
        spatialRelationship = (data["spatialRelationship"] as Int).toSpatialRelationship()
        resultOffset = data["resultOffset"] as Int
    }
}