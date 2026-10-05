//
//  PostDetailAssembly.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import Swinject

final class PostDetailAssembly: Assembly {
    func assemble(container: Container) {
        container.register(PostDetailRepository.self) { _ in
            PostDetailRepositoryImpl()
        }

        container.register(PostDetailInteractor.self) { r in
            PostDetailInteractorImpl(
                repository: r.resolve(PostDetailRepository.self)!
            )
        }

        container.register(PostDetailViewModel.self) { r in
            PostDetailViewModel(
                interactor: r.resolve(PostDetailInteractor.self)!
            )
        }

        container.register(PostDetailViewController.self) { r in
            PostDetailViewController(
                viewModel: r.resolve(PostDetailViewModel.self)!
            )
        }
    }
}
