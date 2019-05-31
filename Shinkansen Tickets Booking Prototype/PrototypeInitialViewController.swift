//
//  PrototypeInitialViewController.swift
//  Shinkansen Tickets Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class PrototypeInitialViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 1)))
        
        print(UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .light)).pointSize)
        
        print(UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .light)).pointSize)
        
        print(UIFontMetrics(forTextStyle: .caption1).scaledFont(for: UIFont.systemFont(ofSize: 24, weight: .light)).pointSize)
   print(Constant.multiplier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(DesignSystemViewController(), animated: true, completion: nil)
    }
}
