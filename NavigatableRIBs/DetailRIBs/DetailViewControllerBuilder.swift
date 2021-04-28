//
//  DetailViewControllerBuilder.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs

protocol DetailViewControllerDependency: Dependency {
}

final class DetailViewControllerComponent: Component<DetailViewControllerDependency> {
}

// MARK: - Builder

protocol DetailViewControllerBuildable: Buildable {
    func build(_ case: MasterExampleCase) -> DetailViewControllerRouting
}

final class DetailViewControllerBuilder: Builder<DetailViewControllerDependency>, DetailViewControllerBuildable {

    func build(_ case: MasterExampleCase) -> DetailViewControllerRouting {
        
        let viewController: DetailViewControllerViewController!
        
        switch `case` {
        case .success:
            viewController = SuccessDetailViewController()
            
        case .forcedExit:
            viewController = ForcedExitDetailViewController()
        }

        let interactor = DetailViewControllerInteractor(presenter: viewController)
        return DetailViewControllerRouter(interactor: interactor, viewController: viewController)
    }
}
