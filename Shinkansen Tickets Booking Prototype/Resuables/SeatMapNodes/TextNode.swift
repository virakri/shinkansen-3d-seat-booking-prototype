//
//  TextNode.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 6/19/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import SceneKit

class TextNode: SCNNode {
    
    private var textContentNode: SCNNode
    
    enum TextAlignment {
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
        print((text.font.lineHeight))
        textContentNode.geometry = text
        textContentNode.eulerAngles.x = -.pi / 2
        textContentNode.position.z = Float(font.pointSize + text.font.capHeight / 2)
        
        // make the text node aligned
        textContentNode.position.x = textAlignment.offsetBy(textContentNode)
        
        addChildNode(textContentNode)
        
    }
}
