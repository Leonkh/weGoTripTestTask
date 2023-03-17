//
//  MainPresenter.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation

protocol MainPresenter {
    
    func didTapCreateReviewButton()
    
}

final class MainPresenterImpl {
    
    // MARK: - Properties
    
    weak var view: MainView?
    private let router: MainRouter
    
    // MARK: - Init
    
    init(router: MainRouter) {
        self.router = router
    }
    
}

extension MainPresenterImpl: MainPresenter {
    
    // MARK: - MainPresenter
    
    func didTapCreateReviewButton() {
        router.presentReviewCreation()
    }
    
}
