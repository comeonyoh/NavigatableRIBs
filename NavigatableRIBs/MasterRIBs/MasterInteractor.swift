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

final class MasterInteractor: PresentableInteractor<MasterPresentable>, MasterInteractable {
    
    var flushRouter: CommonRIBsResourceFlush? {
        router as? CommonRIBsResourceFlush
    }

    weak var router: MasterRouting?
    
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
