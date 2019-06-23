//
//  DesignSystemTextStylesView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DesignSystemTextStylesView: DesignSystemView {
    
    let componentViews: [DesignSystemBlockView] = {
        return [
            .init(withTextStyle: textStyle.largeTitle(),
                  title: "Large Title"),
            .init(withTextStyle: textStyle.headline(),
                  title: "Headline"),
            .init(withTextStyle: textStyle.subheadline(),
                  title: "Subheadline"),
            .init(withTextStyle: textStyle.body(),
                  title: "Body"),
            .init(withTextStyle: textStyle.button(),
                  title: "Button"),
            .init(withTextStyle: textStyle.outlinedButton(),
                  title: "Outlined Button"),
            .init(withTextStyle: textStyle.footnote(),
                  title: "Footnote"),
            .init(withTextStyle: textStyle.caption1(),
                  title: "Caption 1"),
            .init(withTextStyle: textStyle.caption2(),
                  title: "Caption 2")]
    }()
    
    init() {
        super.init(title: "Text Styles",
                   designSystemBlockViews: componentViews)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
