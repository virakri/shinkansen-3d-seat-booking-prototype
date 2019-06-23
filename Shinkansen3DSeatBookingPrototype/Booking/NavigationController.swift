//
//  BookingNavigationController.swift
//  Shinkansen 3D Seat Booking Prototype
//
//  Created by Virakri Jinangkul on 5/14/19.
//  Copyright © 2019 Virakri Jinangkul. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        displayAlertToDismiss()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(preferredColorThemeChanged(_:)),
                                               name: .didColorThemeChange,
                                               object: nil)
    
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarHidden(true, animated: false)
    }
    
    public func displayAlertToDismiss(isEndOfPrototype: Bool = false) {
        
        let title, message: String
        if isEndOfPrototype {
            title = "You're about to exit the Prototype."
            message = "Are you sure you want to proceed this action?"
        }else{
            title = "This is the end of this prototype."
            message = "Are you sure you want to exit the prototype?"
        }
        
        let isIPhone = UIDevice.current.userInterfaceIdiom == .phone
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: isIPhone ? .actionSheet : .alert)
        alert.addAction(UIAlertAction(title: "Exit",
                                      style: .destructive,
                                      handler: { _ in
                                        self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func preferredColorThemeChanged(_ notification: Notification) {
        view.tintColor = currentColorTheme.componentColor.callToAction
    }
}

extension NavigationController: UIViewControllerTransitioningDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return ViewControllerAnimatedTransitioning(isPresenting: operation == .push)
    }
}
