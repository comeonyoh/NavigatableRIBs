//
//  DetailRouter.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs

protocol DetailInteractable: Interactable {
    var router: DetailRouting? { get set }
    var listener: DetailListener? { get set }
}

protocol DetailViewControllable: ViewControllable {
}

final class DetailRouter: ViewableRouter<DetailInteractable, DetailViewControllable>, DetailRouting {

    override init(interactor: DetailInteractable, viewController: DetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func didSuccessivePushButtonClicked() {
        
        let detail = DetailBuilder(dependency: DetailComponent()).build(.successive)

        if let viewController = self.viewController as? NavigationControllable {
            attachChild(detail)
            viewController.pushViewController(detail.viewControllable.uiviewController, animated: true)
        }
    }
}

class DetailComponent: Component<EmptyDependency>, DetailDependency {

    init() {
        super.init(dependency: EmptyComponent())
    }
}
