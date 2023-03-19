//
//  ReviewCreationRateDIAssembly.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation

import Swinject

final class ReviewCreationRateDIAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(ReviewCreationRateView.self) { resolver in
            guard let presenter = resolver.resolve(ReviewCreationRatePresenter.self) else {
                fatalError()
            }
            return ReviewCreationRateViewController(presenter: presenter)
        }
        
        container.register(ReviewCreationRatePresenter.self) { resolver in
            guard let interactor = resolver.resolve(ReviewCreationDataInteractor.self) else {
                fatalError()
            }
            
            return ReviewCreationRatePresenterImpl(reviewCreationDataInteractor: interactor)
        }
        .initCompleted { resover, presenter in
            guard let presenter = presenter as? ReviewCreationRatePresenterImpl else {
                fatalError()
            }
            presenter.view = resover.resolve(ReviewCreationRateView.self)
        }
    }
    
}
