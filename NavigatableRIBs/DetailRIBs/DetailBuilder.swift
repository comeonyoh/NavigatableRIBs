//
//  DetailBuilder.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs

protocol DetailDependency: Dependency {
}

// MARK: - Builder

protocol DetailBuildable: Buildable {
    func build(_ case: MasterExampleCase) -> DetailRouting
}

final class DetailBuilder: Builder<DetailDependency>, DetailBuildable {

    func build(_ case: MasterExampleCase) -> DetailRouting {
        
        let viewController: DetailViewController!
        
        switch `case` {
        case .normal:
            viewController = NormalDetailViewController()
            
        case .exception:
            viewController = NonNavigationControllableDetailViewController()
            
        case .successive:
            viewController = SuccessiveViewController()
        }

        let interactor = DetailInteractor(presenter: viewController)
        return DetailRouter(interactor: interactor, viewController: viewController)
    }
}
