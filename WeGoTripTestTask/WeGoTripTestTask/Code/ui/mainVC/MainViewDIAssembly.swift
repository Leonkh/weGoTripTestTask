//
//  MainViewDIAssembly.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import Swinject

final class MainViewDIAssembly: Assembly {
    
    func assemble(container: Container) {
        container.register(MainView.self) { resolver in
            guard let presenter = resolver.resolve(MainPresenter.self) else {
                fatalError()
            }
            return MainViewController(presenter: presenter)
        }
        
        container.register(MainRouter.self) { resolver in
            guard let assembly = resolver.resolve(ReviewCreationViewAssembly.self) else {
                fatalError()
            }
            
            return MainRouterImpl(reviewCreationViewAssembly: assembly) }
            .initCompleted { resover, router in
                guard let router = router as? MainRouterImpl else {
                    fatalError()
                }
                router.view = resover.resolve(MainView.self)
            }
        
        container.register(MainPresenter.self) { resolver in
            guard let router = resolver.resolve(MainRouter.self) else {
                fatalError()
            }
            
            return MainPresenterImpl(router: router)
        }
        .initCompleted { resover, presenter in
            guard let presenter = presenter as? MainPresenterImpl else {
                fatalError()
            }
            presenter.view = resover.resolve(MainView.self)
        }
    }
    
}
