//
//  CategoryViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 14.10.23.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private var dataManager = DataManager.shared
    
    //MARK: - Layout variables
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "No Photo.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Привычки и события можно\nобъединить по смыслу"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.backgroundColor = .ypGrey
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.accessibilityIdentifier = "addCategoryButton"
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapAddCategoryButton),
            for: .touchUpInside
        )
        button.backgroundColor = .ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        turnOnViews()
        addSubViews()
        applyConstraints()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapAddCategoryButton() {
        let navigatonViewController = UINavigationController(rootViewController: NewCategoryViewController())
        present(navigatonViewController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderTitleLabel)
        view.addSubview(addCategoryButton)
    }
    
    private func turnOnViews() {
        if dataManager.categories.count > 0 {
            tableView.isHidden = false
            placeholderImageView.isHidden = true
            placeholderTitleLabel.isHidden = true
        } else {
            tableView.isHidden = true
            placeholderImageView.isHidden = false
            placeholderTitleLabel.isHidden = false
        }
            
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 21),
            
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(dataManager.categories.count * 75)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 38),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addCategoryButton.topAnchor,constant: -47),
            
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 246),
            
            placeholderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderTitleLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

//MARK: - UITableViewDataSource
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        
        guard let categoryCell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        
        categoryCell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        if indexPath.row == dataManager.categories.count - 1 {
            categoryCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
            }
        
        let category = dataManager.categories[indexPath.row].title
        categoryCell.configureCell(category: category)

        return categoryCell

    }

}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let delegate = delegate else {
//            tableView.deselectRow(at: indexPath, animated: false)
//            return
//        }
//        delegate.updateCategory(category: mockData.getCategories()[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: false)
//        dismiss(animated: true)
    }
}
