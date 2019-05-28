//
//  DesignSystemViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/27/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class DesignSystemViewController: ViewController {
    
    private let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func setupView() {
        super.setupView()
        
        let headlineLabel: UILabel = {
            let label = UILabel()
            label.setText(dummyText, using: .headline)
            label.numberOfLines = 0
            return label
        }()
        
        let subheadlineLabel: UILabel = {
            let label = UILabel()
            label.setText(dummyText, using: .subheadline)
            label.numberOfLines = 0
            return label
        }()
        
        let bodyLabel: UILabel = {
            let label = UILabel()
            label.setText(dummyText, using: .body)
            label.numberOfLines = 0
            return label
        }()
        
        let caption1Label: UILabel = {
            let label = UILabel()
            label.setText(dummyText, using: .caption1)
            label.numberOfLines = 0
            return label
        }()
        
        let caption2Label: UILabel = {
            let label = UILabel()
            label.setText(dummyText, using: .caption2)
            label.numberOfLines = 0
            return label
        }()
        
        let buttonLabel: UILabel = {
            let label = UILabel()
            label.setText(dummyText, using: .button)
            label.numberOfLines = 0
            return label
        }()
        
        let stackView = UIStackView([headlineLabel,
                                     subheadlineLabel,
                                     bodyLabel,
                                     caption1Label,
                                     caption2Label,
                                     buttonLabel],
                                    axis: .vertical,
                                    distribution: .fill,
                                    alignment: .fill,
                                    spacing: 16)
        
        view.addSubview(stackView, withConstaintEquals: [.topSafeArea, .leadingMargin, .trailingMargin])
        
        view.backgroundColor = .white
        
    }
}
