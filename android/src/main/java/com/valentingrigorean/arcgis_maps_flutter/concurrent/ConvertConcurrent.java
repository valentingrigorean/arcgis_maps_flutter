package com.valentingrigorean.arcgis_maps_flutter.concurrent;

import com.esri.arcgisruntime.concurrent.Job;
import com.valentingrigorean.arcgis_maps_flutter.Convert;

import java.util.HashMap;

public class ConvertConcurrent extends Convert {

    public static Object jobMessageToJson(Job.Message message) {
        final HashMap<String, Object> json = new HashMap<>(4);
        json.put("message", message.getMessage());
        json.put("severity", message.getSeverity() == Job.MessageSeverity.UNKNOWN ? -1 : message.getSeverity().ordinal());
        json.put("source", message.getSource().ordinal());
        json.put("timestamp", ISO8601Format.format(message.getTimestamp().getTime()));
        return json;
    }
}
