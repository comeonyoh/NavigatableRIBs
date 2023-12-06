//
//  MasterBuilder.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs

protocol MasterBuildable: Buildable {
    func build() -> MasterRouter
}

final class MasterBuilder: Builder<Dependency>, MasterBuildable {
    
    func build() -> MasterRouter {

        let viewController = initialViewController("MasterViewController") as! MasterViewController
        let interactor = MasterInteractor(presenter: viewController)

        return MasterRouter(interactor: interactor, viewController: viewController)
    }
}
