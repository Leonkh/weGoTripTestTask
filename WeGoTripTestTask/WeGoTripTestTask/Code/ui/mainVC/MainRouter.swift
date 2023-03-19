//
//  MainRouter.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit
import Swinject

protocol MainRouter {
    
    func presentReviewCreation()
    
}

final class MainRouterImpl {
    
    // MARK: - Properties
    
    weak var view: MainView?
    
    private let reviewCreationViewAssemblyProvider: Provider<ReviewCreationViewAssembly>
    
    init(reviewCreationViewAssemblyProvider: Provider<ReviewCreationViewAssembly>) {
        self.reviewCreationViewAssemblyProvider = reviewCreationViewAssemblyProvider
    }
    
}

extension MainRouterImpl: MainRouter {
    
    // MARK: - MainRouter
    
    func presentReviewCreation() {
        let viewController = reviewCreationViewAssemblyProvider.instance.createView()
        view?.present(viewController, animated: true)
    }
    
}
