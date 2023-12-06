//
//  RIBNavigationController.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import UIKit

public protocol CommonRIBsInteractable: Interactable {
    var flushRouter: CommonRIBsResourceFlush? { get }
}

public protocol CommonRIBsResourceFlush {
    func flushRIBsResources()
}

public class CommonRIBsViewController: UIViewController, ViewControllable {
    
    public var flushRouter: CommonRIBsResourceFlush? {
        nil
    }
}

public class CommonRIBsRouter<InteractorType, ViewControllerType>: ViewableRouter<InteractorType, ViewControllerType>, CommonRIBsResourceFlush {
    
    public var nextScreenRouter: ViewableRouting?
    
    @discardableResult
    public func push(nextRouter: ViewableRouting?, animated: Bool) -> Bool {
        
        if nextScreenRouter != nil {
            flushRIBsResources()
        }
        
        guard let next = nextRouter else { return false }
        
        nextScreenRouter = next
        nextScreenRouter?.interactable.activate()
        nextScreenRouter?.load()
        
        viewControllable.uiviewController.navigationController?.pushViewController(next.viewControllable.uiviewController, animated: animated)
        return true
    }

    public func flushRIBsResources() {
        
        nextScreenRouter?.interactable.deactivate()
        nextScreenRouter = nil
    }
}

public class CommonRIBNavigationController: UINavigationController, UINavigationControllerDelegate {

    private var cachedViewController: [UIViewController] = []

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        super.pushViewController(viewController, animated: animated)
        print("Pushed target: \(viewController), child: \(viewController.children)")
        
        if cachedViewController.contains(viewController) == false {
            cachedViewController.append(viewController)
        }
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        
        guard cachedViewController.count > children.count else { return }
        
        guard let currentIndex = cachedViewController.firstIndex(of: viewController), cachedViewController.count > currentIndex + 1 else { return }
        
        //  When the last dismissed view controller is kind of a RIBs.
        guard cachedViewController[currentIndex + 1] is ViewControllable else {

            cachedViewController = Array(cachedViewController[0...currentIndex])
            return
        }
        
        guard let current = cachedViewController[currentIndex] as? CommonRIBsViewController else { return }
        
        current.flushRouter?.flushRIBsResources()
        cachedViewController = Array(cachedViewController[0...currentIndex])
    }
}

