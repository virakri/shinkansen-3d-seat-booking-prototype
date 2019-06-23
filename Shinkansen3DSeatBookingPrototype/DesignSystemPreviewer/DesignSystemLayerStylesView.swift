//
//  DesignSystemLayerStylesView.swift
//  Shinkansen3DSeatBookingPrototype
//
//  Created by Virakri Jinangkul on 6/23/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit
import Kumi

class DesignSystemLayerStylesView: DesignSystemView {
    
    let componentViews: [DesignSystemBlockView] = {
        return [
            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                .LayerStyleState(normal: layerStyle.button.normal(),
                                 highlighted: layerStyle.button.highlighted(),
                                 disabled: layerStyle.button.disabled(),
                                 selected: nil,
                                 focused: nil) , title: "Contained Button")
            ,
            
            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                .LayerStyleState(normal: layerStyle.outlinedButton.normal(),
                                 highlighted: layerStyle.outlinedButton.highlighted(),
                                 disabled: layerStyle.outlinedButton.disabled(),
                                 selected: nil,
                                 focused: nil) , title: "Outlined Button")
            ,
            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                .LayerStyleState(normal: layerStyle.card.normal(),
                                 highlighted: layerStyle.card.highlighted(),
                                 disabled: layerStyle.card.disabled(),
                                 selected: nil,
                                 focused: nil) , title: "Card"),
            
            DesignSystemBlockView(withLayerStylesState: DesignSystemBlockView.LayerStyleView
                .LayerStyleState(normal: layerStyle.largeCard.normal(),
                                 highlighted: layerStyle.largeCard.highlighted(),
                                 disabled: layerStyle.largeCard.disabled(),
                                 selected: nil,
                                 focused: nil) , title: "Large Card")
            ]
    }()
    
    init() {
        
        let accessoryView: UIView = UIView()
        
        super.init(title: "Layer Styles",
                   designSystemBlockViews: componentViews,
                   accessoryView: accessoryView
        )
        
        let stateSegmentedControl = UISegmentedControl(items: ["Normal",
                                                               "Highlighted",
                                                               "Disabled"])
        
        accessoryView.addSubview(stateSegmentedControl,
                                 withConstaintEquals: .marginEdges)
        
        stateSegmentedControl.addTarget(self,
                                        action: #selector(stateSegmentedControlValueChanged(_:)),
                                        for: .valueChanged)
        stateSegmentedControl.selectedSegmentIndex = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func stateSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            state = .normal
        case 1:
            state = .highlighted
        case 2:
            state = .disabled
        default:
            break
        }
    }
}


