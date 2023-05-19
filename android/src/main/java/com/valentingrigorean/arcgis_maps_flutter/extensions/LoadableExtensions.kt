package com.valentingrigorean.arcgis_maps_flutter.extensions

import com.arcgismaps.Loadable
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.joinAll
import kotlinx.coroutines.launch



suspend fun <T : Loadable> Collection<T>.loadAll() = coroutineScope {
        map { loadable ->
            launch {
                loadable.load()
            }
        }.joinAll()
    }
