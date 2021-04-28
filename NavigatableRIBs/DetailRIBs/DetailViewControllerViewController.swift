//
//  DetailViewControllerViewController.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import RxSwift
import UIKit

protocol DetailViewControllerPresentableListener: class {
}

class DetailViewControllerViewController: UIViewController, DetailViewControllerPresentable, DetailViewControllerViewControllable {

    weak var listener: DetailViewControllerPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationItem.title = "Hello RIBs"
    }
    
    var router: Routing? {
        
        guard let interactor = self.listener as? DetailViewControllerInteractor else {
            return nil
        }
        
        return interactor.router
    }
}

class SuccessDetailViewController: DetailViewControllerViewController, NavigationControllable {
    
}

class ForcedExitDetailViewController: DetailViewControllerViewController {
    
}
