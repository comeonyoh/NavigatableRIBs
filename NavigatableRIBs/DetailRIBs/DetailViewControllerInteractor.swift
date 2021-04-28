//
//  DetailViewControllerInteractor.swift
//  NavigatableRIBs
//
//  Created by JungSu Kim on 2021/04/28.
//

import RIBs
import RxSwift

protocol DetailViewControllerRouting: ViewableRouting {
}

protocol DetailViewControllerPresentable: Presentable {
    var listener: DetailViewControllerPresentableListener? { get set }
}

protocol DetailViewControllerListener: class {
}

final class DetailViewControllerInteractor: PresentableInteractor<DetailViewControllerPresentable>, DetailViewControllerInteractable, DetailViewControllerPresentableListener {

    weak var router: DetailViewControllerRouting?
    weak var listener: DetailViewControllerListener?

    override init(presenter: DetailViewControllerPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
}
