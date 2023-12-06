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

final class DetailRouter: ViewableRouter<DetailInteractable, ViewControllable>, DetailRouting {

    override init(interactor: DetailInteractable, viewController: ViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func didSuccessivePushButtonClicked() {
        
        let detail = DetailBuilder(dependency: EmptyComponent()).build(.successive)
        attachChild(detail)
        viewController.uiviewController.navigationController?.pushViewController(detail.viewControllable.uiviewController, animated: true)
    }
}
