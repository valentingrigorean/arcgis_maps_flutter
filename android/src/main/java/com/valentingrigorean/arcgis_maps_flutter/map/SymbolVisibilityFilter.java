package com.valentingrigorean.arcgis_maps_flutter.map;

import java.util.Objects;

public class SymbolVisibilityFilter {
    private final double minZoom;
    private final double maxZoom;

    public SymbolVisibilityFilter(double minZoom, double maxZoom) {
        this.minZoom = minZoom;
        this.maxZoom = maxZoom;
    }

    public double getMinZoom() {
        return minZoom;
    }

    public double getMaxZoom() {
        return maxZoom;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SymbolVisibilityFilter that = (SymbolVisibilityFilter) o;
        return Double.compare(that.minZoom, minZoom) == 0 && Double.compare(that.maxZoom, maxZoom) == 0;
    }

    @Override
    public int hashCode() {
        return Objects.hash(minZoom, maxZoom);
    }
}
