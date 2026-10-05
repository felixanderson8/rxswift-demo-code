//
//  UserListViewController.swift
//  RxSwift-Part1
//
//  Created by Felix Anderson on 9/30/26.
//

import UIKit
import RxSwift

final class UserListViewController: UIViewController {

    private let viewModel: UserListViewModel
    private let disposeBag = DisposeBag()

    private var users: [User] = []

    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let tableView = UITableView()

    lazy var removeButton: UIButton = {
        let config: UIButton.Configuration = .glass()
        let button = UIButton(configuration: config)
        button.setTitle("Remove First Name", for: .normal)
        button.addTarget(self, action: #selector(removeFirstUser), for: .touchUpInside)
        
        return button
    }()

    init(viewModel: UserListViewModel) {
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

        viewModel.loadUsers()
    }

    private func setupUI() {
        view.backgroundColor = .white

        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UserCell")

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        removeButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(removeButton)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: removeButton.topAnchor, constant: -16),

            removeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            removeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            removeButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

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
        
        viewModel.users
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] users in
                self?.users = users
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc func removeFirstUser() {
        viewModel.removeFirstUser()
    }
}

// MARK: - UITableViewDataSource
extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        let user = users[indexPath.row]

        var content = cell.defaultContentConfiguration()
        content.text = user.name
        content.secondaryText = "ID: \(user.id)"
        cell.contentConfiguration = content

        return cell
    }
}
