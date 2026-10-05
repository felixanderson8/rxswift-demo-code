//
//  PostListContainer.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import Swinject

final class PostListAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PostListRepository.self) { _ in
            PostListRepositoryImpl()
        }

        container.register(PostListInteractor.self) { r in
            PostListInteractorImpl(
                repository: r.resolve(PostListRepository.self)!
            )
        }

        container.register(PostListViewModel.self) { r in
            PostListViewModel(
                interactor: r.resolve(PostListInteractor.self)!
            )
        }

        container.register(PostListViewController.self) { r in
            PostListViewController(
                viewModel: r.resolve(PostListViewModel.self)!
            )
        }
    }
}
