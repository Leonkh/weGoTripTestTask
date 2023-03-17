//
//  ReviewCreationView.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import UIKit

protocol ReviewCreationView: UIViewController {
    
}

final class ReviewCreationViewController: UIViewController {
    
    // MARK: - Properties
    
    private let presenter: ReviewCreationPresenter
    
    // MARK: - Init
    
    init(presenter: ReviewCreationPresenter) {
        self.presenter = presenter
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
    
}

extension ReviewCreationViewController: ReviewCreationView {
    
}
