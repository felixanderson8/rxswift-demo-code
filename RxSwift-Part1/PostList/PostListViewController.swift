//
//  PostListViewController.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 10/2/26.
//

import Foundation
import UIKit
import RxSwift
import Swinject

enum PostListNavigation {
    case postDetail(postId: Int)
}

final class PostListViewController: UIViewController {

    private let viewModel: PostListViewModel
    private let disposeBag = DisposeBag()

    private var posts: [Post] = []

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()

    lazy var removeButton: UIButton = {
        let config: UIButton.Configuration = .glass()
        let button = UIButton(configuration: config)

        button.setTitle("Remove First Post", for: .normal)
        button.addTarget(
            self,
            action: #selector(removeFirstPost),
            for: .touchUpInside
        )

        return button
    }()

    init(viewModel: PostListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()

        viewModel.loadPosts()
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "PostCell"
        )

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(removeButton)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(
                equalTo: view.centerXAnchor
            ),
            activityIndicator.centerYAnchor.constraint(
                equalTo: view.centerYAnchor
            ),

            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: removeButton.topAnchor,
                constant: -16
            ),

            removeButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: 20
            ),
            removeButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: -20
            ),
            removeButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -16
            ),
            removeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - RxSwift

    private func bindViewModel() {

        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in

                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)

        viewModel.posts
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] posts in
                self?.posts = posts
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )

                alert.addAction(
                    UIAlertAction(
                        title: "OK",
                        style: .default
                    )
                )

                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)

        viewModel.navigation
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] navigation in

                guard let self else {
                    return
                }

                switch navigation {

                case .postDetail(let postId):
                    self.showPostDetail(postId: postId)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Navigation

    private func showPostDetail(postId: Int) {
        let vm = DIContainer.shared.resolve(PostDetailViewModel.self)
        vm.id = postId

        vm.onDelete = { [weak self] deletedId in
            self?.viewModel.removePost(withId: deletedId)
            self?.navigationController?.popViewController(animated: true)
        }

        let vc = PostDetailViewController(viewModel: vm)

        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Actions

    @objc
    private func removeFirstPost() {
        viewModel.removeFirstPosts()
    }
}

// MARK: - UITableViewDataSource

extension PostListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        posts.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PostCell",
            for: indexPath
        )

        let post = posts[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = post.title
        content.secondaryText = post.body

        cell.contentConfiguration = content

        return cell
    }
}

// MARK: - UITableViewDelegate

extension PostListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.didSelectPost(at: indexPath.row)

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )
    }
}
