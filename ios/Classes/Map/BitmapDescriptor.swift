//
// Created by Valentin Grigorean on 29.03.2021.
//

import Foundation
import ArcGIS

class BitmapDescriptorOptions: NSObject {

    let width: CGFloat?

    let height: CGFloat?

    let fileName: String

    let tintColor: UIColor?

    init(data: Dictionary<String, Any>) {
        fileName = data["fromNativeAsset"] as! String

        if let tintColor = data["tintColor"] {
            self.tintColor = UIColor(data: tintColor)
        } else {
            tintColor = nil
        }

        if let width = data["width"] as? Double {
            self.width = width > 0 ? CGFloat(width) : nil
        } else {
            width = nil
        }
        if let height = data["height"] as? Double {
            self.height = height > 0 ? CGFloat(height) : nil
        } else {
            height = nil
        }
    }
    
    override var hash: Int{
        var hasher = Hasher()
        hasher.combine(width)
        hasher.combine(height)
        hasher.combine(fileName)
        hasher.combine(tintColor)
        return hasher.finalize()
    }

    override func isEqual(_ object: Any?) -> Bool {
        guard let rhs = object as? BitmapDescriptorOptions else {
            return false
        }
        
        if self === rhs {
            return true
        }
        if width != rhs.width {
            return false
        }
        if height != rhs.height {
            return false
        }
        if fileName != rhs.fileName {
            return false
        }
        if tintColor != rhs.tintColor {
            return false
        }
        return true
    }
   
    static func ==(lhs: BitmapDescriptorOptions,
                   rhs: BitmapDescriptorOptions) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.width != rhs.width {
            return false
        }
        if lhs.height != rhs.height {
            return false
        }
        if lhs.fileName != rhs.fileName {
            return false
        }
        if lhs.tintColor != rhs.tintColor {
            return false
        }
        return true
    }

}

class BitmapDescriptor: Hashable {
    private let bitmapDescriptor: FlutterBitmapDescriptor


    init(data: Dictionary<String, Any>) {
        bitmapDescriptor = BitmapDescriptor.createFlutterBitmapDescriptor(data: data)
    }

    func createSymbol() -> AGSSymbol {
        bitmapDescriptor.createSymbol()
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(bitmapDescriptor)
    }

    static func ==(lhs: BitmapDescriptor,
                   rhs: BitmapDescriptor) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.bitmapDescriptor != rhs.bitmapDescriptor {
            return false
        }
        return true
    }

    private static func createFlutterBitmapDescriptor(data: Dictionary<String, Any>) -> FlutterBitmapDescriptor {
        print(data)
        if let fromBytes = data["fromBytes"] as? FlutterStandardTypedData {
            return RawBitmapDescriptor(rawData: fromBytes)
        }
        if (data["fromNativeAsset"] as? String) != nil {
            return AssetBitmapDescriptor(bitmapOptions: BitmapDescriptorOptions(data: data))
        }

        if let descriptors = data["descriptors"] as? [Dictionary<String, Any>] {
            var bitmaps = [FlutterBitmapDescriptor]()
            for descriptor in descriptors {
                bitmaps.append(createFlutterBitmapDescriptor(data: descriptor))
            }
            return CompositeBitmapDescriptor(bitmapDescriptors: bitmaps)
        }

        if let styleMarker = data["styleMarker"] as? Int {
            let color = UIColor(data: data["color"])!
            let size = CGFloat(data["size"] as! Double)
            return StyleMarkerBitmapDescriptor(style: AGSSimpleMarkerSymbolStyle(rawValue: styleMarker)!, color: color, size: size)
        }

        fatalError()
    }
}

fileprivate class FlutterBitmapDescriptor: Hashable {

    func hash(into hasher: inout Hasher) {

    }

    func isEqual(to other: FlutterBitmapDescriptor) -> Bool {
        fatalError("isEqual is not impl")
    }

    static func ==(lhs: FlutterBitmapDescriptor,
                   rhs: FlutterBitmapDescriptor) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }

        return lhs.isEqual(to: rhs)
    }

    func createSymbol() -> AGSSymbol {
        fatalError()
    }
}


fileprivate class RawBitmapDescriptor: FlutterBitmapDescriptor {

    private let rawData: FlutterStandardTypedData

    init(rawData: FlutterStandardTypedData) {
        self.rawData = rawData
    }

    override func createSymbol() -> AGSSymbol {
        AGSPictureMarkerSymbol(image: UIImage(data: rawData.data)!)
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(rawData)
    }

    override func isEqual(to other: FlutterBitmapDescriptor) -> Bool {
        if type(of: self) != type(of: other) {
            return false
        }
        guard let y = other as? RawBitmapDescriptor else {
            return false
        }
        if rawData != y.rawData {
            return false
        }
        return true
    }

    static func ==(lhs: RawBitmapDescriptor,
                   rhs: RawBitmapDescriptor) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.rawData != rhs.rawData {
            return false
        }
        return true
    }
}

fileprivate class AssetBitmapDescriptor: FlutterBitmapDescriptor {

    private let bitmapOptions: BitmapDescriptorOptions

    init(bitmapOptions: BitmapDescriptorOptions) {
        self.bitmapOptions = bitmapOptions
    }

    override func createSymbol() -> AGSSymbol {
        let image = bitmapOptions.getImage()
        let symbol = AGSPictureMarkerSymbol(image: image)

        if let width = bitmapOptions.width {
            symbol.width = width
        }

        if let height = bitmapOptions.height {
            symbol.height = height
        }

        return symbol
    }

    override func isEqual(to other: FlutterBitmapDescriptor) -> Bool {
        if type(of: self) != type(of: other) {
            return false
        }
        guard let y = other as? AssetBitmapDescriptor else {
            return false
        }
        if bitmapOptions != y.bitmapOptions {
            return false
        }
        return true
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(bitmapOptions)
    }

    static func ==(lhs: AssetBitmapDescriptor,
                   rhs: AssetBitmapDescriptor) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.bitmapOptions != rhs.bitmapOptions {
            return false
        }
        return true
    }
}

fileprivate class CompositeBitmapDescriptor: FlutterBitmapDescriptor {
    private let bitmapDescriptors: [FlutterBitmapDescriptor]

    init(bitmapDescriptors: [FlutterBitmapDescriptor]) {
        self.bitmapDescriptors = bitmapDescriptors
        super.init()
    }

    override func createSymbol() -> AGSSymbol {
        var symbols = [AGSSymbol]()

        for bitmap in bitmapDescriptors {
            symbols.append(bitmap.createSymbol())
        }

        return AGSCompositeSymbol(symbols: symbols)
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(bitmapDescriptors)
    }

    override func isEqual(to other: FlutterBitmapDescriptor) -> Bool {
        if type(of: self) != type(of: other) {
            return false
        }
        guard let y = other as? CompositeBitmapDescriptor else {
            return false
        }
        if bitmapDescriptors != y.bitmapDescriptors {
            return false
        }
        return true
    }

    static func ==(lhs: CompositeBitmapDescriptor,
                   rhs: CompositeBitmapDescriptor) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.bitmapDescriptors != rhs.bitmapDescriptors {
            return false
        }
        return true
    }
}

fileprivate class StyleMarkerBitmapDescriptor: FlutterBitmapDescriptor {

    private let style: AGSSimpleMarkerSymbolStyle
    private let color: UIColor
    private let size: CGFloat

    init(style: AGSSimpleMarkerSymbolStyle,
         color: UIColor,
         size: CGFloat) {
        self.style = style
        self.color = color
        self.size = size
    }

    override func createSymbol() -> AGSSymbol {
        AGSSimpleMarkerSymbol(style: style, color: color, size: size)
    }

    override func hash(into hasher: inout Hasher) {
        hasher.combine(style)
        hasher.combine(color)
        hasher.combine(size)
    }

    override func isEqual(to other: FlutterBitmapDescriptor) -> Bool {
        if type(of: self) != type(of: other) {
            return false
        }
        guard let y = other as? StyleMarkerBitmapDescriptor else {
            return false
        }
        if style != y.style {
            return false
        }
        if color != y.color {
            return false
        }
        if size != y.size {
            return false
        }
        return true
    }

    static func ==(lhs: StyleMarkerBitmapDescriptor,
                   rhs: StyleMarkerBitmapDescriptor) -> Bool {
        if lhs === rhs {
            return true
        }
        if type(of: lhs) != type(of: rhs) {
            return false
        }
        if lhs.style != rhs.style {
            return false
        }
        if lhs.color != rhs.color {
            return false
        }
        if lhs.size != rhs.size {
            return false
        }
        return true
    }
}

fileprivate extension BitmapDescriptorOptions {
    func getImage() -> UIImage {
        if let image = ImageCache.sharedInstance.image(for: self) {
            return image
        }
        var image = UIImage(named: fileName)!
        if let color = tintColor {
            image = image.colored(color)
        }
        ImageCache.sharedInstance.insertImage(image, for: self)
        return image
    }
}
