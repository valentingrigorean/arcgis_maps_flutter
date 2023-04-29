package com.valentingrigorean.arcgis_maps_flutter.tasks.networkanalysis

import com.esri.arcgisruntime.UnitSystem
import com.esri.arcgisruntime.tasks.networkanalysis.AttributeParameterValue
import com.esri.arcgisruntime.tasks.networkanalysis.CostAttribute
import com.esri.arcgisruntime.tasks.networkanalysis.CurbApproach
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionEvent
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionManeuver
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionMessage
import com.esri.arcgisruntime.tasks.networkanalysis.DirectionsStyle
import com.esri.arcgisruntime.tasks.networkanalysis.RestrictionAttribute
import com.esri.arcgisruntime.tasks.networkanalysis.Route
import com.esri.arcgisruntime.tasks.networkanalysis.RouteParameters
import com.esri.arcgisruntime.tasks.networkanalysis.RouteResult
import com.esri.arcgisruntime.tasks.networkanalysis.RouteTaskInfo
import com.esri.arcgisruntime.tasks.networkanalysis.Stop
import com.esri.arcgisruntime.tasks.networkanalysis.TravelMode
import com.esri.arcgisruntime.tasks.networkanalysis.UTurnPolicy
import com.valentingrigorean.arcgis_maps_flutter.Convert
import com.valentingrigorean.arcgis_maps_flutter.utils.toMap
import java.util.function.Consumer

object ConvertRouteTask : Convert() {
    fun routeTaskInfoToJson(routeTaskInfo: RouteTaskInfo): Any {
        val json: MutableMap<String, Any?> = HashMap()
        json["accumulateAttributeNames"] = routeTaskInfo.accumulateAttributeNames
        if (routeTaskInfo.costAttributes != null) {
            val costAttributes: MutableMap<String, Any> = HashMap(routeTaskInfo.costAttributes.size)
            routeTaskInfo.costAttributes.forEach { (key: String, value: CostAttribute) ->
                costAttributes[key] = costAttributeToJson(value)
            }
            json["costAttributes"] = costAttributes
        }
        json["defaultTravelModeName"] = routeTaskInfo.defaultTravelModeName
        json["directionsDistanceUnits"] = routeTaskInfo.directionsDistanceUnits.ordinal
        json["directionsLanguage"] = routeTaskInfo.directionsLanguage
        json["directionsStyle"] = routeTaskInfo.directionsStyle.ordinal
        json["findBestSequence"] = routeTaskInfo.isFindBestSequence
        json["maxLocatingDistance"] = routeTaskInfo.maxLocatingDistance
        if (routeTaskInfo.startTime != null) {
            json["startTime"] = Convert.Companion.toCalendarFromISO8601(routeTaskInfo.startTime)
        }
        json["networkName"] = routeTaskInfo.networkName
        if (routeTaskInfo.outputSpatialReference != null) {
            json["outputSpatialReference"] =
                Convert.Companion.spatialReferenceToJson(routeTaskInfo.outputSpatialReference)
        }
        json["preserveFirstStop"] = routeTaskInfo.isPreserveFirstStop
        json["preserveLastStop"] = routeTaskInfo.isPreserveLastStop
        if (routeTaskInfo.restrictionAttributes != null) {
            val restrictionAttributes: MutableMap<String, Any> =
                HashMap(routeTaskInfo.restrictionAttributes.size)
            routeTaskInfo.restrictionAttributes.forEach { (key: String, value: RestrictionAttribute) ->
                restrictionAttributes[key] = restrictionAttributeToJson(value)
            }
            json["restrictionAttributes"] = restrictionAttributes
        }
        json["routeShapeType"] = routeTaskInfo.routeShapeType.ordinal
        json["supportedLanguages"] = routeTaskInfo.supportedLanguages
        json["supportedRestrictionUsageParameterValues"] =
            routeTaskInfo.supportedRestrictionUsageParameterValues
        json["directionsSupport"] = routeTaskInfo.directionsSupport.ordinal
        val travelModes: MutableList<Any> = ArrayList(routeTaskInfo.travelModes.size)
        routeTaskInfo.travelModes.forEach(Consumer { travelMode: TravelMode ->
            travelModes.add(
                travelModeToJson(travelMode)
            )
        })
        json["travelModes"] = travelModes
        json["supportsRerouting"] = routeTaskInfo.isSupportsRerouting
        return json
    }

    fun toRouteParameters(o: Any): RouteParameters {
        val data: Map<*, *> = Convert.Companion.toMap(o)
        val routeParameters = RouteParameters()
        routeParameters.accumulateAttributeNames.addAll(
            (Convert.Companion.toList(
                data["accumulateAttributeNames"]!!
            ) as Collection<String?>)
        )
        routeParameters.directionsDistanceUnits = UnitSystem.values()[Convert.Companion.toInt(
            data["directionsDistanceUnits"]
        )]
        routeParameters.directionsLanguage = data["directionsLanguage"] as String?
        routeParameters.directionsStyle = DirectionsStyle.values()[Convert.Companion.toInt(
            data["directionsStyle"]
        )]
        routeParameters.isFindBestSequence = Convert.Companion.toBoolean(
            data["findBestSequence"]!!
        )
        val startTime = data["startTime"]
        if (startTime != null) {
            routeParameters.startTime =
                Convert.Companion.toCalendarFromISO8601(startTime.toString())
        }
        val outputSpatialReference = data["outputSpatialReference"]
        if (outputSpatialReference != null) {
            routeParameters.outputSpatialReference =
                Convert.Companion.toSpatialReference(outputSpatialReference)
        }
        routeParameters.isPreserveFirstStop = Convert.Companion.toBoolean(
            data["preserveFirstStop"]!!
        )
        routeParameters.isPreserveLastStop = Convert.Companion.toBoolean(
            data["preserveLastStop"]!!
        )
        routeParameters.isReturnDirections = Convert.Companion.toBoolean(
            data["returnDirections"]!!
        )
        routeParameters.isReturnPointBarriers = Convert.Companion.toBoolean(
            data["returnPointBarriers"]!!
        )
        routeParameters.isReturnPolygonBarriers = Convert.Companion.toBoolean(
            data["returnPolygonBarriers"]!!
        )
        routeParameters.isReturnPolylineBarriers = Convert.Companion.toBoolean(
            data["returnPolylineBarriers"]!!
        )
        routeParameters.isReturnRoutes = Convert.Companion.toBoolean(
            data["returnRoutes"]!!
        )
        routeParameters.isReturnStops = Convert.Companion.toBoolean(
            data["returnStops"]!!
        )
        routeParameters.isReturnRoutes = Convert.Companion.toBoolean(
            data["returnRoutes"]!!
        )
        val travelMode = data["travelMode"]
        if (travelMode != null) {
            routeParameters.travelMode = toTravelMode(travelMode)
        }
        val stopsRaw = data["stops"]
        if (stopsRaw != null) {
            val stops: List<*> = Convert.Companion.toList(stopsRaw)
            val routeStops: MutableList<Stop> = ArrayList(stops.size)
            stops.forEach { stop: Any -> routeStops.add(toStop(stop)) }
            routeParameters.setStops(routeStops)
        }
        return routeParameters
    }

    fun routeParametersToJson(routeParameters: RouteParameters): Any {
        val json: MutableMap<String, Any?> = HashMap(17)
        json["accumulateAttributeNames"] = routeParameters.accumulateAttributeNames
        json["directionsDistanceUnits"] = routeParameters.directionsDistanceUnits.ordinal
        json["directionsLanguage"] = routeParameters.directionsLanguage
        json["directionsStyle"] = routeParameters.directionsStyle.ordinal
        json["findBestSequence"] = routeParameters.isFindBestSequence
        if (routeParameters.startTime != null) {
            json["startTime"] = Convert.Companion.toCalendarFromISO8601(
                routeParameters.startTime
            )
        }
        if (routeParameters.outputSpatialReference != null) {
            json["outputSpatialReference"] =
                Convert.Companion.spatialReferenceToJson(
                    routeParameters.outputSpatialReference
                )
        }
        json["preserveFirstStop"] = routeParameters.isPreserveFirstStop
        json["preserveLastStop"] = routeParameters.isPreserveLastStop
        json["returnDirections"] = routeParameters.isReturnDirections
        json["returnPointBarriers"] = routeParameters.isReturnPointBarriers
        json["returnPolygonBarriers"] = routeParameters.isReturnPolygonBarriers
        json["returnPolylineBarriers"] = routeParameters.isReturnPolylineBarriers
        json["returnRoutes"] = routeParameters.isReturnRoutes
        json["returnStops"] = routeParameters.isReturnStops
        json["routeShapeType"] = routeParameters.routeShapeType.ordinal
        if (routeParameters.travelMode != null) {
            json["travelMode"] = travelModeToJson(routeParameters.travelMode)
        }
        return json
    }

    fun routeResultToJson(routeResult: RouteResult): Any {
        val json: MutableMap<String, Any> = HashMap(3)
        json["directionsLanguage"] = routeResult.directionsLanguage
        json["messages"] = routeResult.messages
        val routes: MutableList<Any> = ArrayList(routeResult.routes.size)
        routeResult.routes.forEach(Consumer { route: Route -> routes.add(routeToJson(route)) })
        json["routes"] = routes
        return json
    }

    private fun routeToJson(route: Route): Any {
        val json: MutableMap<String, Any?> = HashMap(13)
        val directionManeuvers: MutableList<Any> = ArrayList(route.directionManeuvers.size)
        route.directionManeuvers.forEach(Consumer { directionManeuver: DirectionManeuver ->
            directionManeuvers.add(
                directionManeuverToJson(directionManeuver)
            )
        })
        json["directionManeuvers"] = directionManeuvers
        if (route.startTime != null) {
            json["startTime"] = Convert.Companion.toCalendarFromISO8601(route.startTime)
        }
        json["startTimeShift"] = route.startTimeShift
        if (route.endTime != null) {
            json["endTime"] = Convert.Companion.toCalendarFromISO8601(route.endTime)
        }
        json["endTimeShift"] = route.endTimeShift
        json["totalLength"] = route.totalLength
        if (route.routeGeometry != null) {
            json["routeGeometry"] = Convert.Companion.geometryToJson(route.routeGeometry)
        }
        val stops: MutableList<Any> = ArrayList(route.stops.size)
        route.stops.forEach(Consumer { stop: Stop -> stops.add(stopToJson(stop)) })
        json["stops"] = stops
        json["routeName"] = route.routeName
        json["totalTime"] = route.totalTime
        json["travelTime"] = route.travelTime
        json["violationTime"] = route.violationTime
        json["waitTime"] = route.waitTime
        return json
    }

    private fun directionManeuverToJson(directionManeuver: DirectionManeuver): Any {
        val json: MutableMap<String, Any?> = HashMap(11)
        val directionEvents: MutableList<Any> = ArrayList(directionManeuver.directionEvents.size)
        directionManeuver.directionEvents.forEach(Consumer { directionEvent: DirectionEvent ->
            directionEvents.add(
                directionEventToJson(directionEvent)
            )
        })
        json["directionEvents"] = directionEvents
        json["directionText"] = directionManeuver.directionText
        if (directionManeuver.estimatedArrivalTime != null) {
            json["estimatedArrivalTime"] =
                Convert.Companion.toCalendarFromISO8601(directionManeuver.estimatedArrivalTime)
        }
        json["estimatedArrivalTimeShift"] = directionManeuver.estimatedArrivalTimeShift
        val maneuverMessages: MutableList<Any> = ArrayList(directionManeuver.maneuverMessages.size)
        directionManeuver.maneuverMessages.forEach(Consumer { maneuverMessage: DirectionMessage ->
            maneuverMessages.add(
                maneuverMessageToJson(maneuverMessage)
            )
        })
        json["maneuverMessages"] = maneuverMessages
        json["fromLevel"] = directionManeuver.fromLevel
        if (directionManeuver.geometry != null) {
            json["geometry"] = Convert.Companion.geometryToJson(directionManeuver.geometry)
        }
        json["maneuverType"] = directionManeuver.maneuverType.ordinal
        json["toLevel"] = directionManeuver.toLevel
        json["length"] = directionManeuver.length
        json["duration"] = directionManeuver.duration
        return json
    }

    private fun maneuverMessageToJson(maneuverMessage: DirectionMessage): Any {
        val json: MutableMap<String, Any> = HashMap(2)
        json["type"] = maneuverMessage.type.ordinal
        json["text"] = maneuverMessage.text
        return json
    }

    private fun directionEventToJson(directionEvent: DirectionEvent): Any {
        val json: MutableMap<String, Any?> = HashMap(5)
        if (directionEvent.estimatedArrivalTime != null) {
            json["estimatedArrivalTime"] =
                Convert.Companion.toCalendarFromISO8601(directionEvent.estimatedArrivalTime)
        }
        json["estimatedArrivalTimeShift"] = directionEvent.estimatedArrivalTimeShift
        val eventMessages: MutableList<String> = ArrayList(directionEvent.eventMessages.size)
        directionEvent.eventMessages.forEach(Consumer { eventMessage: DirectionMessage ->
            eventMessages.add(
                eventMessage.text
            )
        })
        json["eventMessages"] = eventMessages
        json["eventText"] = directionEvent.eventText
        if (directionEvent.geometry != null) {
            json["geometry"] = Convert.Companion.geometryToJson(directionEvent.geometry)
        }
        return json
    }

    private fun toStop(o: Any): Stop {
        val data: Map<*, *> = Convert.Companion.toMap(o)
        val stop = Stop(
            Convert.Companion.toPoint(
                data["geometry"]
            )
        )
        val name = data["name"]
        if (name != null) {
            stop.name = name as String?
        }
        stop.type = Stop.Type.values()[Convert.Companion.toInt(
            data["stopType"]
        )]
        val routeName = data["routeName"]
        if (routeName != null) {
            stop.routeName = routeName as String?
        }
        stop.curbApproach = toCurbApproach(data["curbApproach"])
        stop.currentBearingTolerance =
            Convert.Companion.toDouble(data["currentBearingTolerance"])
        stop.navigationLatency =
            Convert.Companion.toDouble(data["navigationLatency"])
        stop.navigationSpeed =
            Convert.Companion.toDouble(data["navigationSpeed"])
        return stop
    }

    private fun stopToJson(stop: Stop): Any {
        val json: MutableMap<String, Any?> = HashMap()
        json["arrivalCurbApproach"] = curbApproachToJson(stop.arrivalCurbApproach)
        json["departureCurbApproach"] = curbApproachToJson(stop.departureCurbApproach)
        json["curbApproach"] = curbApproachToJson(stop.curbApproach)
        json["currentBearing"] = stop.currentBearing
        json["currentBearingTolerance"] = stop.currentBearingTolerance
        json["distanceToNetworkLocation"] = stop.distanceToNetworkLocation
        if (stop.geometry != null) {
            json["geometry"] =
                Convert.Companion.geometryToJson(stop.geometry)
        }
        if (stop.arrivalTime != null) {
            json["arrivalTime"] =
                Convert.Companion.toCalendarFromISO8601(stop.arrivalTime)
        }
        json["arrivalTimeShift"] = stop.arrivalTimeShift
        if (stop.departureTime != null) {
            json["departureTime"] =
                Convert.Companion.toCalendarFromISO8601(stop.departureTime)
        }
        json["departureTimeShift"] = stop.departureTimeShift
        if (stop.timeWindowStart != null) {
            json["timeWindowStart"] =
                Convert.Companion.toCalendarFromISO8601(stop.timeWindowStart)
        }
        if (stop.timeWindowEnd != null) {
            json["timeWindowEnd"] =
                Convert.Companion.toCalendarFromISO8601(stop.timeWindowEnd)
        }
        json["locationStatus"] = stop.locationStatus.ordinal
        json["name"] = stop.name
        json["stopType"] = stop.type.ordinal
        json["stopID"] = stop.stopId
        json["navigationLatency"] = stop.navigationLatency
        json["navigationSpeed"] = stop.navigationSpeed
        json["routeName"] = stop.routeName
        json["sequence"] = stop.sequence
        json["violationTime"] = stop.violationTime
        json["waitTime"] = stop.waitTime
        return json
    }

    private fun toTravelMode(o: Any): TravelMode {
        val data: Map<*, *> = Convert.Companion.toMap(o)
        val travelMode = TravelMode()
        val attributeParameterValuesRaw: List<*> = Convert.Companion.toList(
            data["attributeParameterValues"]!!
        )
        val attributeParameterValues: MutableList<AttributeParameterValue> =
            ArrayList(attributeParameterValuesRaw.size)
        attributeParameterValuesRaw.forEach { attributeParameterValueRaw: Any ->
            attributeParameterValues.add(
                toAttributeParameterValue(attributeParameterValueRaw)
            )
        }
        travelMode.attributeParameterValues.addAll(attributeParameterValues)
        travelMode.description = data["travelModeDescription"] as String?
        travelMode.distanceAttributeName = data["distanceAttributeName"] as String?
        travelMode.impedanceAttributeName = data["impedanceAttributeName"] as String?
        travelMode.name = data["name"] as String?
        travelMode.outputGeometryPrecision = Convert.Companion.toDouble(
            data["outputGeometryPrecision"]
        )
        travelMode.restrictionAttributeNames.addAll(
            (Convert.Companion.toList(
                data["restrictionAttributeNames"]!!
            ) as Collection<String?>)
        )
        travelMode.timeAttributeName = data["timeAttributeName"] as String?
        travelMode.type = data["type"] as String?
        travelMode.isUseHierarchy = Convert.Companion.toBoolean(
            data["useHierarchy"]!!
        )
        travelMode.uTurnPolicy = UTurnPolicy.values()[Convert.Companion.toInt(
            data["uTurnPolicy"]
        )]
        return travelMode
    }

    private fun travelModeToJson(travelMode: TravelMode): Any {
        val json: MutableMap<String, Any> = HashMap(11)
        val attributeParameterValues: MutableList<Any> =
            ArrayList(travelMode.attributeParameterValues.size)
        travelMode.attributeParameterValues.forEach(Consumer { attributeParameterValue: AttributeParameterValue ->
            attributeParameterValues.add(
                attributeParameterValueToJson(attributeParameterValue)
            )
        })
        json["attributeParameterValues"] = attributeParameterValues
        json["travelModeDescription"] = travelMode.description
        json["distanceAttributeName"] = travelMode.distanceAttributeName
        json["impedanceAttributeName"] = travelMode.impedanceAttributeName
        json["name"] = travelMode.name
        json["outputGeometryPrecision"] = travelMode.outputGeometryPrecision
        json["restrictionAttributeNames"] = travelMode.restrictionAttributeNames
        json["timeAttributeName"] = travelMode.timeAttributeName
        json["type"] = travelMode.type
        json["useHierarchy"] = travelMode.isUseHierarchy
        json["uTurnPolicy"] = travelMode.uTurnPolicy.ordinal
        return json
    }

    private fun costAttributeToJson(costAttribute: CostAttribute): Any {
        val json: MutableMap<String, Any> = HashMap(2)
        if (costAttribute.parameterValues != null) {
            val parameterValues: MutableMap<String, Any> =
                HashMap(costAttribute.parameterValues.size)
            costAttribute.parameterValues.forEach { (key: String, value: Any?) ->
                parameterValues[key] = Convert.Companion.toFlutterFieldType(value)
            }
            json["parameterValues"] = parameterValues
        }
        json["units"] = costAttribute.unit.ordinal
        return json
    }

    private fun restrictionAttributeToJson(restrictionAttribute: RestrictionAttribute): Any {
        val json: MutableMap<String, Any> = HashMap(2)
        if (restrictionAttribute.parameterValues != null) {
            val parameterValues: MutableMap<String, Any> =
                HashMap(restrictionAttribute.parameterValues.size)
            restrictionAttribute.parameterValues.forEach { (key: String, value: Any?) ->
                parameterValues[key] = Convert.Companion.toFlutterFieldType(value)
            }
            json["parameterValues"] = parameterValues
        }
        json["restrictionUsageParameterName"] = restrictionAttribute.restrictionUsageParameterName
        return json
    }

    private fun toAttributeParameterValue(o: Any): AttributeParameterValue {
        val data: Map<*, *> = Convert.Companion.toMap(o)
        val attributeParameterValue = AttributeParameterValue()
        attributeParameterValue.attributeName = data["attributeName"] as String?
        attributeParameterValue.parameterName = data["parameterName"] as String?
        attributeParameterValue.parameterValue =
            Convert.Companion.fromFlutterField(data["parameterValue"])
        return attributeParameterValue
    }

    private fun attributeParameterValueToJson(attributeParameterValue: AttributeParameterValue): Any {
        val json: MutableMap<String, Any> = HashMap(3)
        json["attributeName"] = attributeParameterValue.attributeName
        json["parameterName"] = attributeParameterValue.parameterName
        json["parameterValue"] = Convert.Companion.toFlutterFieldType(
            attributeParameterValue.parameterValue
        )
        return json
    }

    private fun toCurbApproach(o: Any?): CurbApproach {
        val ordinal: Int = Convert.Companion.toInt(o)
        return when (ordinal) {
            4 -> CurbApproach.UNKNOWN
            else -> CurbApproach.values()[ordinal + 1]
        }
    }

    private fun curbApproachToJson(curbApproach: CurbApproach): Int {
        return if (curbApproach == CurbApproach.UNKNOWN) {
            4
        } else curbApproach.ordinal + 1
    }
}