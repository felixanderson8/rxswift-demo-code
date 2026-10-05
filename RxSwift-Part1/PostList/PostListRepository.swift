//
//  PostListRepository.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import RxSwift

protocol PostListRepository {
    func fetchPosts() -> Single<[Post]>
}

final class PostListRepositoryImpl: PostListRepository {

    func fetchPosts() -> Single<[Post]> {
        return Single.create { observer in
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/")!
            
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
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    observer(.success(posts))
                } catch {
                    observer(.failure(error))
                }
            }

            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }.delaySubscription(.seconds(2), scheduler: MainScheduler.instance)
    }
}
