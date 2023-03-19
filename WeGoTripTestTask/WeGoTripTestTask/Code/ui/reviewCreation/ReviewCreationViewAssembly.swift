//
//  ReviewCreationViewAssembly.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit
import Swinject

protocol ReviewCreationViewAssembly {
    
    func createView() -> UIViewController
    
}

final class ReviewCreationViewAssemblyImpl {
    
    // MARK: - Properties
    
    private let coordinator: ReviewCreationCoordinator
    private let view: ReviewCreationRateView
    private lazy var navigationView = ReviewCreationNavigationController(coordinator: coordinator,
                                                                         rootViewController: view)
    
    // MARK: - Init
    
    init(coordinator: ReviewCreationCoordinator,
         view: ReviewCreationRateView) {
        self.coordinator = coordinator
        self.view = view
    }
    
}

extension ReviewCreationViewAssemblyImpl: ReviewCreationViewAssembly {
    
    // MARK: - ReviewCreationViewAssembly
    
    func createView() -> UIViewController {
        view.set(delegate: coordinator as? ReviewCreationRateViewDelegate)
        view.loadViewIfNeeded()
        coordinator.navigationController = navigationView
        coordinator.start()
        return navigationView
    }
    
}
