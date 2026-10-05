//
//  PostListViewModel.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import RxSwift

final class PostListViewModel {

    private let interactor: PostListInteractor
    private let disposeBag = DisposeBag()

    private let postsSubject = BehaviorSubject<[Post]>(value: [])
    private let loadingSubject = BehaviorSubject<Bool>(value: false)
    private let errorSubject = PublishSubject<Error>()
    private let navigationSubject = PublishSubject<PostListNavigation>()

    var posts: Observable<[Post]> {
        postsSubject
    }
    var isLoading: Observable<Bool> {
        loadingSubject
    }
    var error: Observable<Error> {
        errorSubject
    }
    
    var navigation: Observable<PostListNavigation> {
        navigationSubject
    }

    init(interactor: PostListInteractor) {
        self.interactor = interactor
    }

    func loadPosts() {
        loadingSubject.onNext(true)

        interactor.fetchPosts()
            .subscribe(
                onSuccess: { [weak self] users in
                    self?.postsSubject.onNext(users)
                    self?.loadingSubject.onNext(false)
                },
                onFailure: { [weak self] error in
                    self?.loadingSubject.onNext(false)
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func removeFirstPosts() {
        guard var users = try? postsSubject.value(),
            !users.isEmpty else {
            return
        }

        users.removeFirst()
        postsSubject.onNext(users)
    }

    func removePost(withId id: Int) {
        guard var posts = try? postsSubject.value() else {
            return
        }

        posts.removeAll { $0.id == id }
        postsSubject.onNext(posts)
    }
    
    func didSelectPost(at index: Int) {
        guard let posts = try? postsSubject.value(),
              posts.indices.contains(index) else {
            return
        }

        let post = posts[index]

        navigationSubject.onNext(
            .postDetail(postId: post.id)
        )
    }
}
