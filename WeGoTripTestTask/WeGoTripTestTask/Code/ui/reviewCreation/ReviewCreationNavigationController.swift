//
//  ReviewCreationNavigationController.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 19.03.2023.
//

import Foundation
import UIKit

final class ReviewCreationNavigationController: UINavigationController {
    
    private let coordinator: ReviewCreationCoordinator
    
    init(coordinator: ReviewCreationCoordinator,
         rootViewController: UIViewController) {
        self.coordinator = coordinator
        
        super.init(rootViewController: rootViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
