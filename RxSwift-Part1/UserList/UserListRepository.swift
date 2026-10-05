//
//  UserListRepository.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/1/26.
//

import Foundation
import RxSwift

protocol UserListRepository {
    func fetchUsers() -> Single<[User]>
}

final class UserListRepositoryImpl: UserListRepository {

    func fetchUsers() -> Single<[User]> {
        return Single.create { observer in
            let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    observer(.failure(error))
                    return
                }

                guard let data = data else {
                    observer(.failure(NetworkError.emptyResponse))
                    return
                }

                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    observer(.success(users))
                } catch {
                    observer(.failure(error))
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }.delaySubscription(.seconds(5), scheduler: MainScheduler.instance)
    }
}

enum NetworkError: Error {
    case emptyResponse
}
