//
//  MasterInteractor.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import RxSwift

protocol MasterRouting: ViewableRouting {
    func routeToDetail(at case: MasterExampleCase)
}

protocol MasterPresentable: Presentable {
    var listener: MasterPresentableListener? { get set }
}

protocol MasterListener: class {
}

final class MasterInteractor: PresentableInteractor<MasterPresentable>, MasterInteractable {

    weak var router: MasterRouting?
    
    weak var listener: MasterListener?

    override init(presenter: MasterPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}

extension MasterInteractor: MasterPresentableListener {
    
    func didExampleCellSelected(at case: MasterExampleCase) {

        //  Do business logic.
        router?.routeToDetail(at: `case`)
    }
}
