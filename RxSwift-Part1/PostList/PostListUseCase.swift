//
//  PostListUseCase.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import RxSwift

protocol PostListInteractor {
    func fetchPosts() -> Single<[Post]>
}

final class PostListInteractorImpl: PostListInteractor {

    private let repository: PostListRepository

    init(repository: PostListRepository) {
        self.repository = repository
    }

    func fetchPosts() -> Single<[Post]> {
        repository.fetchPosts()
    }
}
