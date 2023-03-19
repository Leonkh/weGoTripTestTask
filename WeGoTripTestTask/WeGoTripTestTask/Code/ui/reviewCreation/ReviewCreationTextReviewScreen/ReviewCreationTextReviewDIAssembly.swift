//
//  ReviewCreationFinalDIAssembly.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 19.03.2023.
//

import Foundation

import Swinject

final class ReviewCreationFinalDIAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.register(ReviewCreationTextReviewView.self) { resolver in
            guard let presenter = resolver.resolve(ReviewCreationTextReviewPresenter.self) else {
                fatalError()
            }
            return ReviewCreationTextReviewViewController(presenter: presenter)
        }
        
        container.register(ReviewCreationTextReviewPresenter.self) { resolver in
            guard let interactor = resolver.resolve(ReviewCreationDataInteractor.self) else {
                fatalError()
            }
            
            return ReviewCreationTextReviewPresenterImpl(reviewCreationDataInteractor: interactor)
        }
        .initCompleted { resover, presenter in
            guard let presenter = presenter as? ReviewCreationTextReviewPresenterImpl else {
                fatalError()
            }
            presenter.view = resover.resolve(ReviewCreationTextReviewView.self)
        }
    }
    
}
