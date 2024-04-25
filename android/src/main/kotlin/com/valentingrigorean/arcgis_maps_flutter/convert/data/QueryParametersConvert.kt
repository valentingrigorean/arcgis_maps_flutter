package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.QueryParameters
import com.valentingrigorean.arcgis_maps_flutter.convert.geometry.toGeometryOrNull

fun Any.toQueryParametersOrNull(): QueryParameters? {
    val data = this as? Map<*, *> ?: return null
    return QueryParameters().apply {
        returnGeometry = data["returnGeometry"] as Boolean
        geometry = data["geometry"]?.toGeometryOrNull()
        data["maxFeatures"]?.let {
            maxFeatures = it as Int
        }
        whereClause = data["whereClause"] as String
        (data["spatialRelationship"] as Int?)?.let {
            spatialRelationship = it.toSpatialRelationship()
        }
        data["resultOffset"]?.let {
            resultOffset =  it as Int
        }
    }
}