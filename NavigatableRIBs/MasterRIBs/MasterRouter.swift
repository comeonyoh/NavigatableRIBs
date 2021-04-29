//
//  MasterRouter.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import UIKit

protocol MasterInteractable: Interactable {
    var router: MasterRouting? { get set }
    var listener: MasterListener? { get set }
}

protocol MasterViewControllable: NavigationControllable {
}

final class MasterRouter: ViewableRouter<MasterInteractable, MasterViewControllable>, MasterRouting, LaunchRouting {
    
    var navigationController: RIBNavigationController!
    
    func launch(from window: UIWindow) {
        
        navigationController = RIBNavigationController(rootViewController: viewControllable.uiviewController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        interactable.activate()
        load()
    }

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MasterInteractable, viewController: MasterViewControllable) {
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToDetail(at case: MasterExampleCase) {
        
        let detail = DetailBuilder(dependency: DetailComponent()).build(`case`)
        
        attachChild(detail)
        self.viewController.pushViewController(detail.viewControllable.uiviewController, animated: true)
    }
}

class MasterCompoment: Component<EmptyDependency>, MasterDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
