//
//  MainRouter.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit

protocol MainRouter {
    
    func presentReviewCreation()
    
}

final class MainRouterImpl {
    
    // MARK: - Properties
    
    weak var view: MainView?
    
    private let reviewCreationViewAssembly: ReviewCreationViewAssembly
    
    init(reviewCreationViewAssembly: ReviewCreationViewAssembly) {
        self.reviewCreationViewAssembly = reviewCreationViewAssembly
    }
    
}

extension MainRouterImpl: MainRouter {
    
    // MARK: - MainRouter
    
    func presentReviewCreation() {
        let viewController = reviewCreationViewAssembly.createView()
        view?.present(viewController, animated: true)
    }
    
}
