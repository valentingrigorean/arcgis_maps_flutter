/*
 * Copyright 2019 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.valentingrigorean.arcgis_maps_flutter.toolkit.extension

/**
 * Extension property that provides a String representing a class name. To be used for Android Logs.
 *
 * @since 100.6.0
 */
val Any.logTag: String
    get() {
        (this::class.simpleName)?.let {
            return it
        }
        return "Unknown class"
    }
