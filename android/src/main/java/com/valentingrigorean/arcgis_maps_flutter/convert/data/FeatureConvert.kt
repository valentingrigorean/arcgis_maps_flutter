//package com.valentingrigorean.arcgis_maps_flutter.convert.data
//
//import com.arcgismaps.data.Feature
//import com.arcgismaps.data.FieldType
//import com.valentingrigorean.arcgis_maps_flutter.convert.toFlutterValue
//import java.time.Instant
//import java.util.UUID
//
//private fun (FieldType).toFlutterType(): String {
//    return when (this) {
//        FieldType.Unknown -> "unknown"
//        FieldType.Guid -> "guid"
//        FieldType.Float64, FieldType.Float32, FieldType.Int16, FieldType.Int32,FieldType.Int64 -> "number"
//        FieldType.Date -> "date"
//        FieldType.Text -> "text"
//        FieldType.Oid -> "oid"
//        FieldType.GlobalId -> "globalid"
//        else -> "ignore"
//    }
//
//fun Feature.toFlutterJson(): Any {
//    val data = HashMap<String, Any>()
//
//    data["displayName"] = this.featureTable?.displayName ?: ""
//    data["tableName"] = this.featureTable?.tableName ?: ""
//
//    data["fields"] = this.featureTable?.fields?.map {
//        mapOf(
//            "alias" to it.alias,
//            "fieldType" to it.fieldType.toFlutterType(),
//            "name" to it.name
//        )
//    } ?: emptyList<Any>()
//
////    val featureTypesList: MutableList<MutableMap<String, Any>> = mutableListOf()
////
////    if (this is ArcGISFeature) {
////        this.featureTable.featureTypes.forEach { ft ->
////            val featureTypeMap: MutableMap<String, Any> = mutableMapOf()
////
////            if (ft.id is String || ft.id is Int || ft.id is Short || ft.id is Double || ft.id is Float) {
////                featureTypeMap["id"] = ft.id
////                featureTypeMap["name"] = ft.name
////                featureTypesList.add(featureTypeMap)
////            }
////        }
//////            this.featureTable.featureTypes
////    }
////
//    data["featureTypes"] = emptyList<Any>() // featureTypesList
//
//
//    val attributesMap: MutableMap<String, Any?> = mutableMapOf()
//    this.attributes.forEach { (key, value) ->
//        val f = this.featureTable?.fields?.firstOrNull {
//            it.name == key
//        }
//        when (f?.fieldType) {
//            FieldType.Int16, FieldType.Int32, FieldType.Int64 -> {
//                attributesMap[key] = value as? Short
//            }
//
//            FieldType.Oid -> {
//                attributesMap[key] = value as? Long
//            }
//
//            FieldType.Float32, FieldType.Float64 -> {
//                attributesMap[key] = value as? Double
//            }
//
//            FieldType.Date -> {
//                attributesMap[key] = (value as? Instant)?.toFlutterValue()
//            }
//
//            FieldType.Text -> {
//                attributesMap[key] = value as? String
//            }
//
//            FieldType.Guid, FieldType.GlobalId -> {
//                val v = value as? UUID
//                attributesMap[key] = v?.toString()
//            }
//
//            else -> {
//                attributesMap[key] = value?.toString()
//            }
//        }
//    }
//    data["attributes"] = attributesMap
//
//    return data
//}