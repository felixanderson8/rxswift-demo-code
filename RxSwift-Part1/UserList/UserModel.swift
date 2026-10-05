//
//  UserModel.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/1/26.
//

import Foundation

struct User: Decodable {
    let id: Int
    let name: String
    let email: String
}
