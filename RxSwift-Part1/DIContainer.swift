//
//  DIContainer.swift
//  RxSwift-Part1
//

import Foundation
import Swinject

protocol IDIContainer {
    static var shared: IDIContainer { get set }
    var container: Container { get set }
    func setupDependencies()
    func resolve<T>(_ serviceType: T.Type) -> T
}

extension IDIContainer {
    func resolve<T>(_ serviceType: T.Type) -> T {
        guard let resolved = container.resolve(serviceType) else {
            fatalError("Failed to resolve \(serviceType)")
        }
        return resolved
    }
}

final class DIContainer: IDIContainer {
    static var shared: IDIContainer = DIContainer()
    var container = Container()
    
    init() {
        setupDependencies()
    }
    
    internal func setupDependencies() {
        let assemblies: [Assembly] = [
            UserListAssembly(),
            PostListAssembly(),
            PostDetailAssembly()
        ]
        
        for assembly in assemblies {
            assembly.assemble(container: container)
        }
    }
}
