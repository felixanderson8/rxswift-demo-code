//
//  UserListViewModel.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/1/26.
//

import Foundation
import RxSwift

final class UserListViewModel {

    private let interactor: UserListInteractor
    private let disposeBag = DisposeBag()

    private let usersSubject = BehaviorSubject<[User]>(value: [])
    private let loadingSubject = BehaviorSubject<Bool>(value: false)
    private let errorSubject = PublishSubject<Error>()

    var users: Observable<[User]> {
        usersSubject
    }
    var isLoading: Observable<Bool> {
        loadingSubject
    }
    var error: Observable<Error> {
        errorSubject
    }

    init(interactor: UserListInteractor) {
        self.interactor = interactor
    }

    func loadUsers() {
        loadingSubject.onNext(true)

        interactor.fetchUsers()
            .subscribe(
                onSuccess: { [weak self] users in
                    self?.usersSubject.onNext(users)
                    self?.loadingSubject.onNext(false)
                },
                onFailure: { [weak self] error in
                    self?.loadingSubject.onNext(false)
                    self?.errorSubject.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func removeFirstUser() {
        guard var users = try? usersSubject.value(),
            !users.isEmpty else {
            return
        }

        users.removeFirst()
        usersSubject.onNext(users)
    }
}
