//
//  ReviewCreationDIAssembly.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import Swinject

final class ReviewCreationDIAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(ReviewCreationViewAssembly.self) { resolver in
            guard let view = resolver.resolve(ReviewCreationView.self) else {
                fatalError()
            }
            return ReviewCreationViewAssemblyImpl(view: view)
        }
        .inObjectScope(.transient)
        
        container.register(ReviewCreationView.self) { resolver in
            guard let presenter = resolver.resolve(ReviewCreationPresenter.self) else {
                fatalError()
            }
            return ReviewCreationViewController(presenter: presenter)
        }
        
        container.register(ReviewCreationPresenter.self) { _ in ReviewCreationPresenterImpl() }
        .initCompleted { resover, presenter in
            guard let presenter = presenter as? ReviewCreationPresenterImpl else {
                fatalError()
            }
            presenter.view = resover.resolve(ReviewCreationView.self)
        }
    }
    
}
