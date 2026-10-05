//
//  PostDetailViewModel.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import RxSwift

protocol PostDetailViewModelProtocol {
    var id: Int { get set }
}

final class PostDetailViewModel: PostDetailViewModelProtocol {
    var id: Int = 0
    var onDelete: ((Int) -> Void)?

    private let interactor: PostDetailInteractor
    private let disposeBag = DisposeBag()

    private let postSubject = PublishSubject<Post>()
    private let loadingSubject = BehaviorSubject<Bool>(value: false)
    private let errorSubject = PublishSubject<Error>()

    var post: Observable<Post> {
        postSubject
    }
    var isLoading: Observable<Bool> {
        loadingSubject
    }
    var error: Observable<Error> {
        errorSubject
    }

    init(interactor: PostDetailInteractor) {
        self.interactor = interactor
    }

    func loadPostDetail() {
        loadingSubject.onNext(true)

        interactor.fetchPostDetail(id: id)
            .subscribe(
                onSuccess: { [weak self] users in
                    self?.postSubject.onNext(users)
                    self?.loadingSubject.onNext(false)
                },
                onFailure: { [weak self] error in
                    self?.loadingSubject.onNext(false)
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }

    func deletePost() {
        onDelete?(id)
    }
}
