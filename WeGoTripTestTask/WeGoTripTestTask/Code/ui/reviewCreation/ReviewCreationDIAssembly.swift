//
//  ReviewCreationDIAssembly.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import Swinject

final class ReviewCreationDIAssembly: Assembly {
    
    let reviewCreationRateDIAssembly = ReviewCreationRateDIAssembly()
    let reviewCreationFinalDIAssembly = ReviewCreationFinalDIAssembly()
    
    func assemble(container: Container) {
        container.register(ReviewCreationDataInteractor.self, factory: { _ in ReviewCreationDataInteractorImpl() })
        
        reviewCreationFinalDIAssembly.assemble(container: container)
        
        container.register(ReviewCreationCoordinator.self, factory: { resolver in
            guard let reviewCreationTextReviewViewProvider = resolver.resolve(Provider<ReviewCreationTextReviewView>.self) else {
                fatalError()
            }
            guard let reviewCreationDataInteractor = resolver.resolve(ReviewCreationDataInteractor.self) else {
                fatalError()
            }
            
            return ReviewCreationCoordinatorImpl(reviewCreationTextReviewViewProvider: reviewCreationTextReviewViewProvider,
                                                 reviewCreationDataInteractor: reviewCreationDataInteractor)
        })
        
        reviewCreationRateDIAssembly.assemble(container: container)
        
        container.register(ReviewCreationViewAssembly.self) { resolver in
            guard let view = resolver.resolve(ReviewCreationRateView.self) else {
                fatalError()
            }
            guard let coordinator = resolver.resolve(ReviewCreationCoordinator.self) else {
                fatalError()
            }
            
            return ReviewCreationViewAssemblyImpl(coordinator: coordinator,
                                                  view: view)
        }
        .inObjectScope(.transient)
        
    }
    
}
