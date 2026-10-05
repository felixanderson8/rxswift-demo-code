//
//  MainController.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import UIKit

final class MainViewController: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
        setupTabs()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
    }

    private func setupTabs() {
        let postListVC = DIContainer.shared.resolve(PostListViewController.self)
        let postsNav = UINavigationController(rootViewController: postListVC)
        postsNav.tabBarItem = UITabBarItem(
            title: "Posts",
            image: UIImage(systemName: "doc.text"),
            selectedImage: UIImage(systemName: "doc.text.fill")
        )

        let userListVC = DIContainer.shared.resolve(UserListViewController.self)
        let usersNav = UINavigationController(rootViewController: userListVC)
        usersNav.tabBarItem = UITabBarItem(
            title: "Users",
            image: UIImage(systemName: "person.2"),
            selectedImage: UIImage(systemName: "person.2.fill")
        )

        viewControllers = [postsNav, usersNav]
    }

    private func setupAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.backgroundColor = .systemBackground
    }
}
