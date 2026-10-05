//
//  PostDetailUseCase.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import RxSwift

protocol PostDetailInteractor {
    func fetchPostDetail(id: Int) -> Single<Post>
}

final class PostDetailInteractorImpl: PostDetailInteractor {
    private let repository: PostDetailRepository

    init(repository: PostDetailRepository) {
        self.repository = repository
    }
    
    func fetchPostDetail(id: Int) -> Single<Post> {
        repository.fetchPostDetail(id: id)
    }
}
