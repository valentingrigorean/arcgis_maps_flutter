//
// Created by Valentin Grigorean on 14.09.2021.
//

import Foundation
import ArcGIS


class FlutterServiceImageTiledLayer: ServiceImageTiledLayer {
    private let urlTemplate: String
    private let subdomains: [String]
    private let additionalOptions: Dictionary<String, String>

    init(tileInfo: AGSTileInfo,
         fullExtent: AGSEnvelope,
         urlTemplate: String,
         subdomains: [String],
         additionalOptions: Dictionary<String, String>
    ) {
        self.urlTemplate = urlTemplate
        self.subdomains = subdomains
        self.additionalOptions = additionalOptions
        super.init(tileInfo: tileInfo, fullExtent: fullExtent)
        urlForTileKeyHandler = getTileUrl
    }

    private func getTileUrl(tileKey: AGSTileKey) -> URL {

        var url = urlTemplate.replacingOccurrences(of: "{z}", with: String(tileKey.level))
                .replacingOccurrences(of: "{x}", with: String(tileKey.column))
                .replacingOccurrences(of: "{y}", with: String(tileKey.row))


        guard urlTemplate.contains("{s}"), subdomains.count > 0 else {
            return createUrl(url: url)
        }

        let subdomain = tileKey.level + tileKey.row + tileKey.column;

        url = url.replacingOccurrences(of: "{s}", with: subdomains[subdomain % subdomains.count])
        return createUrl(url: url)
    }

    private func createUrl(url: String) -> URL {
        guard additionalOptions.count > 0 else {
            return URL(string: url)!
        }
        var urlComps = URLComponents(string: url)!
        var queryItems = [URLQueryItem]()
        for (key, val) in additionalOptions {
            queryItems.append(URLQueryItem(name: key, value: val))
        }

        urlComps.queryItems = queryItems
        return urlComps.url!
    }
}
