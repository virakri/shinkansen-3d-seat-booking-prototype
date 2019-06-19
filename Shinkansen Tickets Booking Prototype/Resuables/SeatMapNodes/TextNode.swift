//
//  TextNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/19/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class TextNode: SCNNode, Decodable {
    
    private var textContentNode: SCNNode
    
    enum TextAlignment: String, Codable {
        case left
        case center
        case right
        
        func offsetBy(_ contentNode: SCNNode) -> Float {
            switch self {
            case .left:
                return 0
            case .center:
                return -(contentNode.boundingBox.max.x - contentNode.boundingBox.min.x) / 2
            case .right:
                return -contentNode.boundingBox.max.x
            }
        }
    }
    
    var textAlignment: TextAlignment = .center
    
    var text: String?
    
    init(text: String? = nil,
         font: UIFont =
        .systemFont(ofSize: 0.25,
                    weight: .medium),
         textAlignment: TextAlignment = .center,
         color: UIColor,
         estimatedWidth: CGFloat = 1) {
        
        textContentNode = SCNNode()
        super.init()
        setupNode(text: text,
                  font: font,
                  textAlignment: textAlignment,
                  color: color,
                  estimatedWidth: estimatedWidth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(from decoder: Decoder) throws {
        textContentNode = SCNNode()
        super.init()
        let container = try decoder.container(keyedBy: Key.self)
        let text = try container.decode(String.self, forKey: .text)
        textAlignment = try container.decode(TextAlignment.self, forKey: .textAlignment)
        let font = try container.decode(FontModel.self, forKey: .font).font()
        setupNode(text: text,
                  font: font,
                  textAlignment: textAlignment,
                  color: currentColorTheme.componentColor.secondaryText,
                  estimatedWidth: 1)
        position = try container.decode(SCNVector3.self, forKey: .position)
        eulerAngles = try container.decode(SCNVector3.self, forKey: .rotation)
    }
    
    private func setupNode(text: String?,
                           font: UIFont,
                           textAlignment: TextAlignment,
                           color: UIColor,
                           estimatedWidth: CGFloat) {
        
        let text = SCNText(string: text, extrusionDepth: 0.005)
        text.firstMaterial?.diffuse.contents = color
        text.font = font
        text.flatness = 0.6 / ( 36 / font.pointSize )
        text.containerFrame = CGRect(x: 0, y: 0, width: estimatedWidth, height: font.pointSize)
        textContentNode.geometry = text
        textContentNode.eulerAngles.x = -.pi / 2
        textContentNode.position.z = Float(font.pointSize + text.font.capHeight / 2)
        
        // make the text node aligned
        textContentNode.position.x = textAlignment.offsetBy(textContentNode)
        
        addChildNode(textContentNode)
        
    }
    
    enum Key: String, CodingKey {
        case text, font, textAlignment, position, rotation
    }
}

private struct FontModel: Decodable {
    let size: CGFloat
    let weight: UIFont.Weight
    
    enum Key: String, CodingKey {
        case size, weight
    }
    
    func font() -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)
        size = try container.decode(CGFloat.self, forKey: .size)
        switch try container.decode(String.self, forKey: .weight) {
        case "black":
            weight = .black
        case "bold":
            weight = .bold
        case "medium":
            weight = .medium
        case "regular":
            weight = .regular
        case "semibold":
            weight = .semibold
        case "thin":
            weight = .thin
        case "light":
            weight = .light
        case "ultralight":
            weight = .ultraLight
        default:
            weight = .regular
        }
    }
}
