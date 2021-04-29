//
//  DetailInteractor.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import RxSwift

protocol DetailRouting: ViewableRouting {
    func didSuccessivePushButtonClicked()
}

protocol DetailPresentable: Presentable {
    var listener: DetailPresentableListener? { get set }
}

protocol DetailListener: class {
}

final class DetailInteractor: PresentableInteractor<DetailPresentable>, DetailInteractable, DetailPresentableListener {

    weak var router: DetailRouting?
    weak var listener: DetailListener?

    override init(presenter: DetailPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    func didSuccessivePushButtonClicked() {
        router?.didSuccessivePushButtonClicked()
    }
}
