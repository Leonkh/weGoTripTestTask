//
//  ReviewCreationViewAssembly.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation

protocol ReviewCreationViewAssembly {
    
    func createView() -> ReviewCreationView
    
}

final class ReviewCreationViewAssemblyImpl {
    
    private let view: ReviewCreationView
    
    init(view: ReviewCreationView) {
        self.view = view
    }
    
}

extension ReviewCreationViewAssemblyImpl: ReviewCreationViewAssembly {
    
    func createView() -> ReviewCreationView {
        return view
    }
    
}
