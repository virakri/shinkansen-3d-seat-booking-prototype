//
//  SCNMaterial.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Nattawut Singhchai on 11/6/2562 BE.
//  Copyright © 2562 Virakri Jinangkul. All rights reserved.
//

import SceneKit

extension SCNMaterial {
    
    @discardableResult
    func clone(from: SCNMaterial, name: String? = nil) -> SCNMaterial {
        let materialProperties: [(SCNMaterial) -> SCNMaterialProperty] = [
        { $0.diffuse },
        { $0.ambient },
        { $0.specular },
        { $0.emission },
        { $0.transparent },
        { $0.reflective },
        { $0.multiply },
        { $0.normal },
        { $0.displacement },
        { $0.ambientOcclusion },
        { $0.selfIllumination },
        { $0.metalness },
        { $0.roughness },
        ]
        materialProperties.forEach { property in
            copy(from: from, property: property)
        }
        
        // Copy Opacity and Blending
        transparency = from.transparency
        transparencyMode = from.transparencyMode
        blendMode = from.blendMode
        
        if let name = name {
            self.name = name
        }
        return self
    }
    
    @discardableResult
    private func copy(from: SCNMaterial, property: (SCNMaterial) -> SCNMaterialProperty ) -> SCNMaterial {
        let fromProperty = property(from)
        let toProperty = property(self)
        toProperty.contents = fromProperty.contents
        toProperty.intensity = fromProperty.intensity
        return self
    }
}
