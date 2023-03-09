package com.valentingrigorean.arcgis_maps_flutter.utils

import com.esri.arcgisruntime.data.ArcGISFeature
import com.esri.arcgisruntime.data.Feature
import com.esri.arcgisruntime.data.Field
import com.esri.arcgisruntime.data.StatisticType
import com.valentingrigorean.arcgis_maps_flutter.Convert
import java.util.*


internal fun String?.toStatisticType(): StatisticType = when (this) {
    "AVERAGE" -> StatisticType.AVERAGE
    "COUNT" -> StatisticType.COUNT
    "MAXIMUM" -> StatisticType.MAXIMUM
    "MINIMUM" -> StatisticType.MINIMUM
    "STANDARD_DEVIATION" -> StatisticType.STANDARD_DEVIATION
    "SUM" -> StatisticType.SUM
    "VARIANCE" -> StatisticType.VARIANCE
    else -> StatisticType.SUM
}

fun (Field.Type).toFlutterType(): String {
    return when (this) {
        Field.Type.UNKNOWN -> "unknown"
        Field.Type.GUID -> "guid"
        Field.Type.DOUBLE, Field.Type.SHORT, Field.Type.INTEGER, Field.Type.FLOAT -> "number"
        Field.Type.DATE -> "date"
        Field.Type.TEXT -> "text"
        Field.Type.OID -> "oid"
        Field.Type.GLOBALID -> "globalid"
        Field.Type.BLOB, Field.Type.GEOMETRY, Field.Type.RASTER, Field.Type.XML -> "ignore"
    }
}

fun Feature.toMap(): Map<String, Any> {
    val resultMap: MutableMap<String, Any> = mutableMapOf()
    resultMap["geometry"] = Convert.geometryToJson(this.geometry)
    if (this.geometry != null) {
        resultMap["geometryJson"] = this.geometry.toJson()
    }
    val featureTableMap: MutableMap<String, Any> = mutableMapOf()

    featureTableMap["displayName"] = this.featureTable.displayName
    featureTableMap["tableName"] = this.featureTable.tableName

    val fields: List<Map<String, Any>> = this.featureTable.fields.orEmpty().map {
        mapOf(
            "alias" to it.alias,
            "fieldType" to it.fieldType.toFlutterType(),
            "name" to it.name
        )
    }
    featureTableMap["fields"] = fields

    val featureTypesList: MutableList<MutableMap<String, Any>> = mutableListOf()

    if (this is ArcGISFeature) {
        this.featureTable.featureTypes.forEach { ft ->
            val featureTypeMap: MutableMap<String, Any> = mutableMapOf()

            if (ft.id is String || ft.id is Int || ft.id is Short || ft.id is Double || ft.id is Float) {
                featureTypeMap["id"] = ft.id
                featureTypeMap["name"] = ft.name
                featureTypesList.add(featureTypeMap)
            }
        }
//            this.featureTable.featureTypes
    }

    featureTableMap["featureTypes"] = featureTypesList

    resultMap["featureTable"] = featureTableMap

    val attributesMap: MutableMap<String, Any?> = mutableMapOf()


    this.attributes.orEmpty().forEach { (key, value) ->
        val f = this.featureTable.fields.firstOrNull {
            it.name == key
        }
        when (f?.fieldType) {
            Field.Type.SHORT -> {
                attributesMap[key] = value as? Short
            }
            Field.Type.INTEGER -> {
                attributesMap[key] = value as? Int
            }
            Field.Type.OID -> {
                attributesMap[key] = value as? Long
            }
            Field.Type.FLOAT -> {
                attributesMap[key] = value as? Float
            }
            Field.Type.DOUBLE -> {
                attributesMap[key] = value as? Double
            }
            Field.Type.DATE -> {
                attributesMap[key] = (value as? Calendar)?.timeInMillis
            }
            Field.Type.TEXT -> {
                attributesMap[key] = value as? String
            }
            Field.Type.GUID, Field.Type.GLOBALID -> {
                val v = value as? UUID
                attributesMap[key] = v?.toString()
            }
            null, Field.Type.UNKNOWN, Field.Type.GEOMETRY, Field.Type.RASTER, Field.Type.XML, Field.Type.BLOB -> {
                attributesMap[key] = null
            }
        }
    }

    resultMap["attributes"] = attributesMap
    return resultMap
}