//
//  DesignSystemColorsView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DesignSystemColorsView: DesignSystemView {
    
    let componentViews: [DesignSystemBlockView] = {
        return [
            DesignSystemBlockView(withColor: UIColor.accent().main,
                                  title: "Accent Main"),
            DesignSystemBlockView(withColor: UIColor.accent().dark,
                                  title: "Accent Dark"),
            DesignSystemBlockView(withColor: UIColor.accent().light,
                                  title: "Accent Light"),
            DesignSystemBlockView(withColor: UIColor.basic.black,
                                  title: "Basic Black"),
            DesignSystemBlockView(withColor: UIColor.basic.offBlack,
                                  title: "Basic Off Black"),
            DesignSystemBlockView(withColor: UIColor.basic().gray,
                                  title: "Basic Gray"),
            DesignSystemBlockView(withColor: UIColor.basic.offWhite,
                                  title: "Basic Off White"),
            DesignSystemBlockView(withColor: UIColor.basic.white,
                                  title: "Basic White"),
        ]
    }()
    
    init() {
        super.init(title: "Colors",
                   designSystemBlockViews: componentViews)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

