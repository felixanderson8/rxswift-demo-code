//
//  PostDetailRepository.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import RxSwift

protocol PostDetailRepository {
    func fetchPostDetail(id: Int) -> Single<Post>
}

final class PostDetailRepositoryImpl: PostDetailRepository {

    func fetchPostDetail(id: Int) -> Single<Post> {
        return Single.create { observer in
            let url = URL(string: "https://jsonplaceholder.typicode.com/posts/\(id)")!
            
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
                    let post = try JSONDecoder().decode(Post.self, from: data)
                    observer(.success(post))
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
