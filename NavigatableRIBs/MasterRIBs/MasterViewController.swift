//
//  MasterViewController.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import RxSwift
import UIKit

protocol MasterPresentableListener: class {
    func didExampleCellSelected(at case: MasterExampleCase)
}

enum MasterExampleCase: Int, CaseIterable {
    
    case normal
    case exception
    case successive
    
    var description: String {
        switch self {
        case .normal:
            return "Normal case"
            
        case .exception:
            return "Exception case"
            
        case .successive:
            return "Successive case"
        }
    }
}

final class MasterViewController: UIViewController, MasterPresentable, MasterViewControllable {

    weak var listener: MasterPresentableListener?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "Example cases"
    }
    
    var router: Routing? {
        
        guard let interactor = self.listener as? MasterInteractor else {
            return nil
        }
        
        return interactor.router
    }

}

extension MasterViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MasterExampleCase.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "MasterExampleCell", for: indexPath)
        cell.textLabel?.text = MasterExampleCase(rawValue: indexPath.row)?.description
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.didExampleCellSelected(at: MasterExampleCase(rawValue: indexPath.row)!)
    }
}

extension MasterViewController: NavigationDetector {}

func storyboard(_ name: String) -> UIStoryboard {
    UIStoryboard(name: name, bundle: .main)
}

func initialViewController(_ name: String) -> UIViewController {
    storyboard(name).instantiateInitialViewController()!
}
