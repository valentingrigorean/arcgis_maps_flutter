package com.valentingrigorean.arcgis_maps_flutter.utils;

public class StringUtils {
    public static boolean areEqual(String s1, String s2) {
        if (s1 == null && s2 == null)
            return true;
        if (s1 == null || s2 == null)
            return false;
        return s1.equals(s2);
    }
}
