package com.valentingrigorean.arcgis_maps_flutter.service_table

import com.esri.arcgisruntime.data.*
import com.esri.arcgisruntime.geometry.Geometry
import com.valentingrigorean.arcgis_maps_flutter.Convert
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class ServiceTableController(messenger: BinaryMessenger) :
    MethodChannel.MethodCallHandler {

    private var channel: MethodChannel =
        MethodChannel(messenger, "plugins.flutter.io/service_table")

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "queryFeatures" -> {
                queryFeatures(call, result)
            }
            else -> {}
        }
    }

    fun dispose() {
        channel.setMethodCallHandler(null)
    }

    private fun queryFeatures(call: MethodCall, result: MethodChannel.Result) {
        val serviceFeatureTable = ServiceFeatureTable(call.argument<String?>("url"))
        val queryParametersMap: Map<Any, Any> =
            call.argument<Map<Any, Any>?>("queryParameters").orEmpty()
        val whereClauseParam: String? = queryParametersMap["whereClause"] as String?
        val spatialRelationshipParam: QueryParameters.SpatialRelationship? =
            when (queryParametersMap["spatialRelationship"] as String?) {
                "UNKNOWN" -> QueryParameters.SpatialRelationship.UNKNOWN
                "RELATE" -> QueryParameters.SpatialRelationship.RELATE
                "EQUALS" -> QueryParameters.SpatialRelationship.EQUALS
                "DISJOINT" -> QueryParameters.SpatialRelationship.DISJOINT
                "INTERSECTS" -> QueryParameters.SpatialRelationship.INTERSECTS
                "TOUCHES" -> QueryParameters.SpatialRelationship.TOUCHES
                "CROSSES" -> QueryParameters.SpatialRelationship.CROSSES
                "WITHIN" -> QueryParameters.SpatialRelationship.WITHIN
                "CONTAINS" -> QueryParameters.SpatialRelationship.CONTAINS
                "OVERLAPS" -> QueryParameters.SpatialRelationship.OVERLAPS
                "ENVELOPE_INTERSECTS" -> QueryParameters.SpatialRelationship.ENVELOPE_INTERSECTS
                "INDEX_INTERSECTS" -> QueryParameters.SpatialRelationship.INDEX_INTERSECTS
                else -> null
            }

        val geometryParamJson = queryParametersMap["geometry"]

        var geometryParam: Geometry? = null
        if (geometryParamJson != null) {
            geometryParam = Convert.toGeometry(geometryParamJson)
        }

        val query = QueryParameters().apply {
            isReturnGeometry = queryParametersMap["isReturnGeometry"] as Boolean

            if (geometryParam != null) {
                geometry = geometryParam
            }
            maxFeatures = queryParametersMap["maxFeatures"] as Int
            if (whereClauseParam != null) {
                whereClause = whereClauseParam
            }
            if (spatialRelationshipParam != null) {
                spatialRelationship = spatialRelationshipParam
            }
            this.resultOffset = queryParametersMap["resultOffset"] as Int
        }

        val queryFields = when (call.argument<String?>("queryFields")) {
            "IDS_ONLY" -> ServiceFeatureTable.QueryFeatureFields.IDS_ONLY
            "MINIMUM" -> ServiceFeatureTable.QueryFeatureFields.MINIMUM
            "LOAD_ALL" -> ServiceFeatureTable.QueryFeatureFields.LOAD_ALL
            else -> ServiceFeatureTable.QueryFeatureFields.LOAD_ALL
        }
        val future = serviceFeatureTable.queryFeaturesAsync(query, queryFields)
        future.addDoneListener {

            val features = future.get().map {
                it.toMap()
            }.toList()

            result.success(
                mapOf<String, List<Any>>(
                    "features" to features
                )
            )
        }

    }

    private fun Feature.toMap(): Map<String, Any> {
        val resultMap: MutableMap<String, Any> = mutableMapOf()
        resultMap["geometry"] = Convert.geometryToJson(this.geometry)
        if (this.geometry != null) {
            resultMap["geometryJson"] = this.geometry.toJson()
        }
        resultMap["centerPoint"] = mapOf(
            "x" to this.geometry?.extent?.center?.x,
            "y" to this.geometry?.extent?.center?.y
        )
        val featureTableMap: MutableMap<String, Any> = mutableMapOf()

        featureTableMap["displayName"] = this.featureTable.displayName
        featureTableMap["tableName"] = this.featureTable.tableName

        val fields: List<Map<String, Any>> = this.featureTable.fields.orEmpty().map {
            mapOf(
                "alias" to it.alias,
                "fieldType" to toFlutterType(it.fieldType),
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

    private fun toFlutterType(type: Field.Type): String {
        return when (type) {
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
}