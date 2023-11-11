//
//  CategoryViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 14.10.23.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    // MARK: - Stored properties
    
    weak var delegate: CategoryViewControllerDelegate?
    private var trackerCategoryStore = TrackerCategoryStore.shared
    private var categories: [TrackerCategory] = []
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    //MARK: - Layout variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "No Photo.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var placeholderTitleLabel: UILabel = {
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
        tableView.backgroundColor = .ypBackgroundDay
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
        reloadData()
        view.backgroundColor = .ypWhiteDay
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        turnOnViews()
        addSubViews()
        applyConstraints()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapAddCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let navigatonViewController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigatonViewController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func calculateTableViewHeight() -> CGFloat {
        return CGFloat(categories.count * 75)
    }
    
    private func reloadData() {
        categories = trackerCategoryStore.trackerCategory
    }
    
    private func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderTitleLabel)
        view.addSubview(addCategoryButton)
    }
    
    private func turnOnViews() {
        if categories.count > 0 {
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
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: calculateTableViewHeight())
        tableViewHeightConstraint?.isActive = true
    }
}

//MARK: - UITableViewDataSource

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath)
        
        guard let categoryCell = cell as? CategoryCell else {
            return UITableViewCell()
        }
        
        categoryCell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        if indexPath.row == categories.count - 1 {
            categoryCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        }
        
        let category = categories[indexPath.row].title
        categoryCell.configureCell(category: category)
        
        return categoryCell
    }
}

//MARK: - UITableViewDelegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        let category = categories[indexPath.row].title
        delegate.updateCategory(category: category)
        tableView.deselectRow(at: indexPath, animated: false)
        dismiss(animated: true)
    }
}

//MARK: - NewCategoryViewControllerDelegate

extension CategoryViewController: NewCategoryViewControllerDelegate {
    func addNewCategories(category: TrackerCategory) {
        if !categories.contains(where: { $0.title == category.title }) {
            categories.append(category)
            tableView.reloadData()
            turnOnViews()
            
            tableViewHeightConstraint?.constant = calculateTableViewHeight()
        }
    }
}
