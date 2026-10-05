//
//  UseCase.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import RxSwift

protocol UserListInteractor {
    func fetchUsers() -> Single<[User]>
}

final class UserListInteractorImpl: UserListInteractor {

    private let repository: UserListRepository

    init(repository: UserListRepository) {
        self.repository = repository
    }

    func fetchUsers() -> Single<[User]> {
        repository.fetchUsers()
    }
}
