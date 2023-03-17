//
//  ApplicationDIContainer.swift
//  WeGoTripTestTask
//
//  Created by lr.habibullin on 17.03.2023.
//

import Foundation
import Swinject

final class ApplicationDIContainer {
    
    // MARK: - Properties
    
    static let shared = ApplicationDIContainer()
    
    let container = Container()
    let assembler: Assembler
    
    // MARK: - Init
    
    init() {
        assembler = Assembler(
            [
                MainViewDIAssembly(),
                ReviewCreationDIAssembly()
            ],
            container: container)
    }
    
    // MARK: - Internal methods
    
    func resolve<T>() -> T {
        guard let resolvedType = container.resolve(T.self) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T>(registrationName: String?) -> T {
        guard let resolvedType = container.resolve(T.self, name: registrationName) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg>(argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg1, Arg2>(arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg>(name: String?, argument: Arg) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, argument: argument) else {
            fatalError()
        }
        return resolvedType
    }
    
    func resolve<T, Arg1, Arg2>(name: String?, arguments arg1: Arg1, _ arg2: Arg2) -> T {
        guard let resolvedType = container.resolve(T.self, name: name, arguments: arg1, arg2) else {
            fatalError()
        }
        return resolvedType
    }
    
}
