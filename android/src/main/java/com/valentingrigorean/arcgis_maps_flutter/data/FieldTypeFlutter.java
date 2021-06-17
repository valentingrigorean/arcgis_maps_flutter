package com.valentingrigorean.arcgis_maps_flutter.data;

public enum FieldTypeFlutter {
    UNKNOWN(0),
    INTEGER(1),
    DOUBLE(2),
    DATE(3),
    TEXT(4),
    NULLABLE(5);

    private final int value;

    FieldTypeFlutter(int value) {
        this.value = value;
    }

    public int getValue() {
        return value;
    }
}
