//
//  DetailViewControllerRouter.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs

protocol DetailViewControllerInteractable: Interactable {
    var router: DetailViewControllerRouting? { get set }
    var listener: DetailViewControllerListener? { get set }
}

protocol DetailViewControllerViewControllable: ViewControllable {
}

final class DetailViewControllerRouter: ViewableRouter<DetailViewControllerInteractable, DetailViewControllerViewControllable>, DetailViewControllerRouting {

    override init(interactor: DetailViewControllerInteractable, viewController: DetailViewControllerViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
