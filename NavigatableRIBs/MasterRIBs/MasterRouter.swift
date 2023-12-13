//
//  MasterRouter.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import UIKit

protocol MasterInteractable: CommonRIBsInteractable {
    var router: MasterRouting? { get set }
}

final class MasterRouter: CommonRIBsRouter <MasterInteractable, ViewControllable>, MasterRouting, LaunchRouting {
    
    var navigationController: CommonRIBNavigationController!
    var tabbar: UITabBarController!
    
    func launch(from window: UIWindow) {
        
        navigationController = CommonRIBNavigationController(rootViewController: viewControllable.uiviewController)
        tabbar = UITabBarController()
        tabbar.setViewControllers([navigationController], animated: false)
        window.rootViewController = tabbar
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MasterInteractable, viewController: ViewControllable) {
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToDetail(at case: MasterExampleCase) {
        
        let detail = DetailBuilder(dependency: EmptyComponent()).build(`case`)
        push(nextRouter: detail, animated: true)
    }
}
