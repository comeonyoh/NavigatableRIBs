//
//  NavigationComponent.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import UIKit

protocol NavigationControllable: ViewControllable {
    
    var router: Routing? { get }
    
    func pushViewController(_ viewController: UIViewController, animated: Bool)
}

extension NavigationControllable where Self: UIViewController {
    
    func pushViewController(_ viewController: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
}

protocol NavigationDetector {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool)
}

extension NavigationDetector where Self: UIViewController & NavigationControllable {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard let children = router?.children, children.count > 0 else {
            return
        }
        
        for child in children {
            router?.detachChild(child, true)
        }
    }
}

extension Routing {
    
    func detachChild(_ child: Routing, _ recursive: Bool) {
        
        if recursive == true && child.children.count > 0 {

            for innerChild in child.children {
                child.detachChild(innerChild, true)
            }
        }

        detachChild(child)
    }
}
