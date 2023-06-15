package com.valentingrigorean.arcgis_maps_flutter.convert.data

import com.arcgismaps.data.QueryFeatureFields
import com.arcgismaps.data.SortOrder
import com.arcgismaps.data.SpatialRelationship
import com.arcgismaps.data.StatisticType

fun Int.toStatisticType(): StatisticType = when (this) {
    0 -> StatisticType.Average
    1 -> StatisticType.Count
    2 -> StatisticType.Maximum
    3 -> StatisticType.Minimum
    4 -> StatisticType.StandardDeviation
    5 -> StatisticType.Sum
    6 -> StatisticType.Variance
    else -> throw IllegalArgumentException("Unknown statistic type $this")
}

fun SpatialRelationship.toFlutterValue(): Int {
    return when (this) {
        SpatialRelationship.Unknown -> -1
        SpatialRelationship.Relate -> 0
        SpatialRelationship.Equals -> 1
        SpatialRelationship.Disjoint -> 2
        SpatialRelationship.Intersects -> 3
        SpatialRelationship.Touches -> 4
        SpatialRelationship.Crosses -> 5
        SpatialRelationship.Within -> 6
        SpatialRelationship.Contains -> 7
        SpatialRelationship.Overlaps -> 8
        SpatialRelationship.EnvelopeIntersects -> 9
        SpatialRelationship.IndexIntersects -> 10
    }
}

fun Int.toSpatialRelationship(): SpatialRelationship {
    return when (this) {
        -1 -> SpatialRelationship.Unknown
        0 -> SpatialRelationship.Relate
        1 -> SpatialRelationship.Equals
        2 -> SpatialRelationship.Disjoint
        3 -> SpatialRelationship.Intersects
        4 -> SpatialRelationship.Touches
        5 -> SpatialRelationship.Crosses
        6 -> SpatialRelationship.Within
        7 -> SpatialRelationship.Contains
        8 -> SpatialRelationship.Overlaps
        9 -> SpatialRelationship.EnvelopeIntersects
        10 -> SpatialRelationship.IndexIntersects
        else -> throw IllegalArgumentException("Unknown spatial relationship $this")
    }
}

fun Int.toSortOrder(): SortOrder {
    return when (this) {
        0 -> SortOrder.Ascending
        1 -> SortOrder.Descending
        else -> throw IllegalArgumentException("Unknown sort order $this")
    }
}

fun Int.toQueryFeatureFields(): QueryFeatureFields {
    return when (this) {
        0 -> QueryFeatureFields.IdsOnly
        1 -> QueryFeatureFields.Minimum
        2 -> QueryFeatureFields.LoadAll
        else -> throw IllegalArgumentException("Unknown query feature fields $this")
    }
}



