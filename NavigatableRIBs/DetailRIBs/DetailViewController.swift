//
//  DetailViewController.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import RxSwift
import UIKit

protocol DetailPresentableListener: class {
    func didSuccessivePushButtonClicked()
}

class DetailViewController: UIViewController, DetailPresentable, DetailViewControllable {

    weak var listener: DetailPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationItem.title = "Hello RIBs"
    }
    
    var router: Routing? {
        
        guard let interactor = self.listener as? DetailInteractor else {
            return nil
        }
        
        return interactor.router
    }
    
    deinit {
        print("Deinit \(self)")
    }
}

class NormalDetailViewController: DetailViewController, NavigationControllable {
    
}

class NonNavigationControllableDetailViewController: DetailViewController {
}

class SuccessiveViewController: DetailViewController, NavigationControllable, NavigationDetector {
    
    var successiveButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        print("Success View Controller: \(self)")
        guard let count = self.navigationController?.children.count else {
            return
        }
        
        self.navigationItem.title = "Succesive Step \(count)"
        
        let margin: CGFloat = 45
        
        successiveButton = UIButton(type: .roundedRect)
        successiveButton.backgroundColor = .white
        successiveButton.setTitleColor(.darkText, for: .normal)
        successiveButton.setTitle("Successive Push", for: .normal)
        successiveButton.frame = .init(x: margin, y: margin * 3, width: self.view.bounds.width - margin * 2, height: margin * 1)
        successiveButton.addTarget(self, action: #selector(didSuccessiveButtonClicked(_:)), for: .touchUpInside)
        
        self.view.addSubview(successiveButton)
    }
    
    @objc
    func didSuccessiveButtonClicked(_ sender: Any) {
        listener?.didSuccessivePushButtonClicked()
    }
}
