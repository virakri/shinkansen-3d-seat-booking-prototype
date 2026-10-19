import Foundation
import SceneKit
import AppKit
import PDFKit

let fm = FileManager.default
let cwd = fm.currentDirectoryPath
let repoRoot = fm.fileExists(atPath: "\(cwd)/Shinkansen3DSeatBookingPrototype") ? cwd : URL(fileURLWithPath: cwd).deletingLastPathComponent().path
let rootDir = "\(repoRoot)/web"

func ensureDir(_ path: String) {
    try? fm.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
}

ensureDir("\(rootDir)/assets/scn/maps")
ensureDir("\(rootDir)/assets/scn/withShadow")
ensureDir("\(rootDir)/assets/data")
ensureDir("\(rootDir)/assets/images/seat-classes")
ensureDir("\(rootDir)/assets/images/trains")
ensureDir("\(rootDir)/assets/images/icons")
ensureDir("\(rootDir)/assets/images/app-icon")

// 1. Copy 3D textures
let mapsDir = "\(repoRoot)/Shinkansen3DSeatBookingPrototype/SeatMap.scnassets/maps"
if let mapFiles = try? fm.contentsOfDirectory(atPath: mapsDir) {
    for f in mapFiles where f.hasSuffix(".png") {
        let src = "\(mapsDir)/\(f)"
        let dst = "\(rootDir)/assets/scn/maps/\(f)"
        try? fm.removeItem(atPath: dst)
        try! fm.copyItem(atPath: src, toPath: dst)
    }
}

let shadowDir = "\(repoRoot)/Shinkansen3DSeatBookingPrototype/SeatMap.scnassets/withShadow"
if let shadowFiles = try? fm.contentsOfDirectory(atPath: shadowDir) {
    for f in shadowFiles where f.hasSuffix(".png") || f.hasSuffix(".json") {
        let src = "\(shadowDir)/\(f)"
        let dst = "\(rootDir)/assets/scn/withShadow/\(f)"
        try? fm.removeItem(atPath: dst)
        try! fm.copyItem(atPath: src, toPath: dst)
    }
}

// 2. Copy JSON Data Sources
let dataSources: [(String, String)] = [
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Data Sources/ModelData.dataset/data.json", "assets/data/ModelData.json"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Data Sources/SeatMap.dataset/SeatMap.json", "assets/data/SeatMap.json"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Data Sources/TrainCriteria.dataset/TrainCriteria.json", "assets/data/TrainCriteria.json")
]
for (srcRel, dstRel) in dataSources {
    let src = "\(repoRoot)/\(srcRel)"
    let dst = "\(rootDir)/\(dstRel)"
    try? fm.removeItem(atPath: dst)
    try! fm.copyItem(atPath: src, toPath: dst)
}

// 3. Copy Seat Class PNGs
for cls in ["gran", "green", "ordinary"] {
    let src = "\(repoRoot)/Shinkansen3DSeatBookingPrototype/Assets.xcassets/Seat Class Images/\(cls).imageset/\(cls).png"
    let dst = "\(rootDir)/assets/images/seat-classes/\(cls).png"
    try? fm.removeItem(atPath: dst)
    try! fm.copyItem(atPath: src, toPath: dst)
}

// 4. Copy AppIcon PNGs
let appIconDir = "\(repoRoot)/Shinkansen3DSeatBookingPrototype/Assets.xcassets/AppIcon.appiconset"
if let iconFiles = try? fm.contentsOfDirectory(atPath: appIconDir) {
    for f in iconFiles where f.hasSuffix(".png") {
        let src = "\(appIconDir)/\(f)"
        let dst = "\(rootDir)/assets/images/app-icon/\(f)"
        try? fm.removeItem(atPath: dst)
        try! fm.copyItem(atPath: src, toPath: dst)
    }
}

// 5. Render PDF assets at @3x PNG using PDFKit/AppKit & copy original PDFs
func renderPDFToPNG(pdfPath: String, pngPath: String, scale: CGFloat = 3.0) {
    guard let doc = PDFDocument(url: URL(fileURLWithPath: pdfPath)),
          let page = doc.page(at: 0) else {
        fatalError("Failed to load PDF: \(pdfPath)")
    }
    let bounds = page.bounds(for: .mediaBox)
    let pixelW = Int(round(bounds.width * scale))
    let pixelH = Int(round(bounds.height * scale))
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixelW,
        pixelsHigh: pixelH,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        fatalError("Failed to create bitmap rep")
    }
    NSGraphicsContext.saveGraphicsState()
    let ctx = NSGraphicsContext(bitmapImageRep: rep)!
    NSGraphicsContext.current = ctx
    let cg = ctx.cgContext
    cg.clear(CGRect(x: 0, y: 0, width: CGFloat(pixelW), height: CGFloat(pixelH)))
    cg.scaleBy(x: scale, y: scale)
    page.draw(with: .mediaBox, to: cg)
    NSGraphicsContext.restoreGraphicsState()
    let pngData = rep.representation(using: .png, properties: [:])!
    try! pngData.write(to: URL(fileURLWithPath: pngPath))
}

for train in ["e2-series", "e3-series", "e4-series", "e5-series", "e6-series", "e7-series"] {
    let pdfSrc = "\(repoRoot)/Shinkansen3DSeatBookingPrototype/Assets.xcassets/Train Sets/\(train).imageset/\(train).pdf"
    let pdfDst = "\(rootDir)/assets/images/trains/\(train).pdf"
    let pngDst = "\(rootDir)/assets/images/trains/\(train).png"
    try? fm.removeItem(atPath: pdfDst)
    try! fm.copyItem(atPath: pdfSrc, toPath: pdfDst)
    renderPDFToPNG(pdfPath: pdfSrc, pngPath: pngDst, scale: 3.0)
}

let iconPDFs: [(String, String)] = [
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/colorThemeModeIcon.imageset/colorThemeModeIcon.pdf", "colorThemeModeIcon"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Logo JR East.imageset/logo_jr_east.pdf", "logo_jr_east"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/iconUncheckedSymbol.imageset/iconUncheckedSymbol.pdf", "iconUncheckedSymbol"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/iconCheckedSymbol.imageset/iconCheckedSymbol.pdf", "iconCheckedSymbol"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Icon Arrow Right.imageset/icon_arrow_right.pdf", "icon_arrow_right"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/symbol-close-button.imageset/symbol-close-button.pdf", "symbol-close-button"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/seatIcon.imageset/seatIcon.pdf", "seatIcon"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Seat Class Icons/Icon Gran.imageset/icon_gran.pdf", "icon_gran"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Seat Class Icons/Icon Green Car.imageset/icon_green_car.pdf", "icon_green_car"),
    ("Shinkansen3DSeatBookingPrototype/Assets.xcassets/Seat Class Icons/Icon Ordinary.imageset/icon_ordinary.pdf", "icon_ordinary")
]

for (srcRel, name) in iconPDFs {
    let pdfSrc = "\(repoRoot)/\(srcRel)"
    let pdfDst = "\(rootDir)/assets/images/icons/\(name).pdf"
    let pngDst = "\(rootDir)/assets/images/icons/\(name).png"
    try? fm.removeItem(atPath: pdfDst)
    try! fm.copyItem(atPath: pdfSrc, toPath: pdfDst)
    renderPDFToPNG(pdfPath: pdfSrc, pngPath: pngDst, scale: name == "seatIcon" ? 0.5 : 3.0)
}

// 6. Extract all 50 SceneKit .scn files into binary + JSON
var binaryData = Data()

func appendAligned(_ data: Data) -> (offset: Int, byteLength: Int) {
    let rem = binaryData.count % 4
    if rem != 0 {
        binaryData.append(Data(repeating: 0, count: 4 - rem))
    }
    let offset = binaryData.count
    binaryData.append(data)
    return (offset, data.count)
}

func extractColorOrTexture(_ contents: Any?) -> [String: Any] {
    guard let contents = contents else {
        return ["type": "color", "color": [1.0, 1.0, 1.0, 1.0]]
    }
    if let color = contents as? NSColor {
        if let srgb = color.usingColorSpace(.sRGB) {
            return [
                "type": "color",
                "color": [
                    Double(srgb.redComponent),
                    Double(srgb.greenComponent),
                    Double(srgb.blueComponent),
                    Double(srgb.alphaComponent)
                ]
            ]
        }
    }
    let str = String(describing: contents)
    if str.hasSuffix(".png") || str.contains(".png") {
        // Normalize path relative to assets/scn/
        if let range = str.range(of: "SeatMap.scnassets/") {
            let rel = String(str[range.upperBound...])
            return ["type": "texture", "path": "assets/scn/\(rel)"]
        } else {
            return ["type": "texture", "path": "assets/scn/\(str)"]
        }
    }
    return ["type": "color", "color": [1.0, 1.0, 1.0, 1.0]]
}

func serializeMaterial(_ mat: SCNMaterial) -> [String: Any] {
    return [
        "name": mat.name ?? "",
        "lightingModel": mat.lightingModel.rawValue,
        "diffuse": extractColorOrTexture(mat.diffuse.contents),
        "diffuseIntensity": Double(mat.diffuse.intensity),
        "multiply": extractColorOrTexture(mat.multiply.contents),
        "multiplyIntensity": Double(mat.multiply.intensity),
        "transparent": extractColorOrTexture(mat.transparent.contents),
        "transparentIntensity": Double(mat.transparent.intensity),
        "transparency": Double(mat.transparency),
        "transparencyMode": mat.transparencyMode.rawValue,
        "blendMode": mat.blendMode.rawValue,
        "cullMode": mat.cullMode.rawValue,
        "isDoubleSided": mat.isDoubleSided,
        "writesToDepthBuffer": mat.writesToDepthBuffer,
        "readsFromDepthBuffer": mat.readsFromDepthBuffer
    ]
}

let stateNames: Set<String> = ["normal", "highlighted", "selected", "disabled", "focus"]

func serializeNode(_ node: SCNNode) -> [String: Any] {
    var dict: [String: Any] = [
        "name": node.name ?? "",
        "position": [Double(node.simdPosition.x), Double(node.simdPosition.y), Double(node.simdPosition.z)],
        "quaternion": [Double(node.simdOrientation.imag.x), Double(node.simdOrientation.imag.y), Double(node.simdOrientation.imag.z), Double(node.simdOrientation.real)],
        "eulerAngles": [Double(node.simdEulerAngles.x), Double(node.simdEulerAngles.y), Double(node.simdEulerAngles.z)],
        "scale": [Double(node.simdScale.x), Double(node.simdScale.y), Double(node.simdScale.z)]
    ]

    // Check for state transform child nodes (normal, highlighted, selected, disabled, focus)
    var stateTransforms: [String: Any] = [:]
    if let parent = node.parent {
        for child in node.childNodes {
            if let cname = child.name, stateNames.contains(cname) && child.geometry == nil && child.childNodes.isEmpty {
                let convertedTransform = parent.convertTransform(child.transform, from: node)
                let temp = SCNNode()
                temp.transform = convertedTransform
                stateTransforms[cname] = [
                    "position": [Double(temp.simdPosition.x), Double(temp.simdPosition.y), Double(temp.simdPosition.z)],
                    "quaternion": [Double(temp.simdOrientation.imag.x), Double(temp.simdOrientation.imag.y), Double(temp.simdOrientation.imag.z), Double(temp.simdOrientation.real)],
                    "eulerAngles": [Double(temp.simdEulerAngles.x), Double(temp.simdEulerAngles.y), Double(temp.simdEulerAngles.z)],
                    "scale": [Double(temp.simdScale.x), Double(temp.simdScale.y), Double(temp.simdScale.z)]
                ]
            }
        }
    }
    if !stateTransforms.isEmpty {
        dict["stateTransforms"] = stateTransforms
    }

    if let geo = node.geometry {
        var geoDict: [String: Any] = [:]
        if let vSrc = geo.sources(for: .vertex).first {
            let info = appendAligned(vSrc.data)
            geoDict["vertex"] = [
                "byteOffset": info.offset,
                "byteLength": info.byteLength,
                "count": vSrc.vectorCount
            ]
        }
        if let nSrc = geo.sources(for: .normal).first {
            let info = appendAligned(nSrc.data)
            geoDict["normal"] = [
                "byteOffset": info.offset,
                "byteLength": info.byteLength,
                "count": nSrc.vectorCount
            ]
        }
        if let uvSrc = geo.sources(for: .texcoord).first {
            let info = appendAligned(uvSrc.data)
            geoDict["texcoord"] = [
                "byteOffset": info.offset,
                "byteLength": info.byteLength,
                "count": uvSrc.vectorCount
            ]
        }

        var elemsArray: [[String: Any]] = []
        for elem in geo.elements {
            let info = appendAligned(elem.data)
            elemsArray.append([
                "primitiveCount": elem.primitiveCount,
                "bytesPerIndex": elem.bytesPerIndex,
                "byteOffset": info.offset,
                "byteLength": info.byteLength
            ])
        }
        geoDict["elements"] = elemsArray

        // Replicate StaticNode.createMaterialMap logic
        let allMaterials = geo.materials.map { serializeMaterial($0) }
        var baseMaterialNames: [String] = []
        for mat in geo.materials {
            if let name = mat.name, name.contains("-") {
                var parts = name.split(separator: "-").map(String.init)
                if let last = parts.last, stateNames.contains(last), parts.count > 1 {
                    if last == "normal" {
                        parts.removeLast()
                        baseMaterialNames.append(parts.joined(separator: "-"))
                    }
                } else {
                    baseMaterialNames.append(name)
                }
            } else {
                baseMaterialNames.append(mat.name ?? "")
            }
        }
        geoDict["allMaterials"] = allMaterials
        geoDict["baseMaterialNames"] = baseMaterialNames
        dict["geometry"] = geoDict
    }

    var childrenArray: [[String: Any]] = []
    for child in node.childNodes {
        if let cname = child.name, stateNames.contains(cname) && child.geometry == nil && child.childNodes.isEmpty {
            continue
        }
        childrenArray.append(serializeNode(child))
    }
    if !childrenArray.isEmpty {
        dict["children"] = childrenArray
    }

    return dict
}

// Read ModelData.json to map model names -> .scn filenames
let modelDataRaw = try! Data(contentsOf: URL(fileURLWithPath: "\(rootDir)/assets/data/ModelData.json"))
let modelDataJson = try! JSONSerialization.jsonObject(with: modelDataRaw) as! [[String: Any]]

var modelsIndex: [String: Any] = [:]
let scnDir = "\(repoRoot)/Shinkansen3DSeatBookingPrototype/SeatMap.scnassets"

for item in modelDataJson {
    let modelName = item["name"] as! String
    let resource = item["resource"] as! String
    let isInteractible = item["isInteractible"] as! Bool
    let scnPath = "\(scnDir)/\(resource)"
    guard fm.fileExists(atPath: scnPath) else {
        print("Skipping missing resource in ModelData.json: \(resource)")
        continue
    }
    let refNode = SCNReferenceNode(url: URL(fileURLWithPath: scnPath))!
    refNode.load()
    guard let protoNode = refNode.childNodes.first else { continue }
    let bs = protoNode.boundingSphere
    let serialized = serializeNode(protoNode)
    modelsIndex[modelName] = [
        "name": modelName,
        "resource": resource,
        "isInteractible": isInteractible,
        "boundingSphere": [
            "center": [Double(bs.center.x), Double(bs.center.y), Double(bs.center.z)],
            "radius": Double(bs.radius)
        ],
        "rootNode": serialized
    ]
}

try! binaryData.write(to: URL(fileURLWithPath: "\(rootDir)/assets/scn/models.bin"))
let modelsJsonData = try! JSONSerialization.data(withJSONObject: modelsIndex, options: [])
try! modelsJsonData.write(to: URL(fileURLWithPath: "\(rootDir)/assets/scn/models.json"))

print("Extracted \(modelsIndex.count) 3D models. Binary size: \(binaryData.count) bytes, JSON size: \(modelsJsonData.count) bytes.")
