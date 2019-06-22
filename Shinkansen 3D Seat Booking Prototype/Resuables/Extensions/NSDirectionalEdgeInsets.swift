//
//  NSDirectionalEdgeInsets.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/30/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

extension NSDirectionalEdgeInsets {
    init(vertical: CGFloat, horizontal: CGFloat) {
        self.init(top: vertical,
              leading: horizontal,
              bottom: vertical,
              trailing: horizontal)
    }
    
    init(top: CGFloat? = nil,
         leading: CGFloat? = nil,
         bottom: CGFloat? = nil,
         trailing: CGFloat? = nil) {
        
        self.init(top: top ?? 0,
                  leading: leading ?? 0,
                  bottom: bottom ?? 0,
                  trailing: trailing ?? 0)
        
    }
}
