//
//  UserListContainer.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import Swinject

final class UserListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UserListRepository.self) { _ in
            UserListRepositoryImpl()
        }

        container.register(UserListInteractor.self) { r in
            UserListInteractorImpl(
                repository: r.resolve(UserListRepository.self)!
            )
        }

        container.register(UserListViewModel.self) { r in
            UserListViewModel(
                interactor: r.resolve(UserListInteractor.self)!
            )
        }

        container.register(UserListViewController.self) { r in
            UserListViewController(
                viewModel: r.resolve(UserListViewModel.self)!
            )
        }
    }
}
