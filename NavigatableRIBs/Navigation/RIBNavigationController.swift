//
//  RIBNavigationController.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import UIKit

class RIBNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if let topViewController = self.topViewController, topViewController.isKind(of: UINavigationController.classForCoder()) == false {
            assert(topViewController is NavigationDetector, "Current topViewController must be NavigationDetector.")
        }
        
        assert(viewController is NavigationControllable, "Only 'NavigationControllable' UIViewController can be pushed on the stack.")
        
        super.pushViewController(viewController, animated: animated)
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {

        if let detector = viewController as? NavigationDetector {
            detector.navigationController(navigationController, didShow: viewController, animated: animated)
        }
    }
}

