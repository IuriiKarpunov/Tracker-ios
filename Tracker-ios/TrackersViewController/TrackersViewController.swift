//
//  ViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 01.10.23.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Subview Properties
    
    var categories: [TrackerCategory] = DataManager.shared.categories
    var completedTrackers: [TrackerRecord] = []
    var visibleCategories: [TrackerCategory] = []
    var currentDate: Date?
    
    //MARK: - Layout variables
    
    private let navBarItem: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "PlusButton.png")
        button.accessibilityIdentifier = "plusButton"
        button.setImage(image, for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapPlusButton),
            for: .touchUpInside
        )
        button.tintColor = .ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(
            TrackersViewController.self,
            action: #selector(datePickerValueChanged(_:)),
            for: .valueChanged
        )
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = .ypBlackDay
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "titleLabel"
        
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let search = UISearchTextField()
        search.placeholder = "Поиск"
        search.borderStyle = .roundedRect
        search.autocorrectionType = .no
        search.autocapitalizationType = .none
        search.clearButtonMode = .whileEditing
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false

        return search
    }()
    
    private let placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "No Photo.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "placeholderTitleLabel"
        
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(
            TreckersCollectionViewCell.self,
            forCellWithReuseIdentifier: TreckersCollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            TrackerHeaderCollectionViewCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerHeaderCollectionViewCell.reuseIdentifier
        )

        addSubViews()
        applyConstraints()
    }

    // MARK: - IBAction
    
    @objc
    private func didTapPlusButton() {
        let creatingTrackerViewController = CreatingTrackerViewController()
        creatingTrackerViewController.delegate = self
        
//        let navigatonViewController = UINavigationController(rootViewController: CreatingTrackerViewController())
        present(creatingTrackerViewController, animated: true)
    }
    
    @objc
    private func datePickerValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yy"
                let selectedDate = dateFormatter.string(from: sender.date)
                print("Выбранная дата: \(selectedDate)")
        }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(navBarItem)
        view.addSubview(plusButton)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTextField)
        if categories.count != 0 {
            view.addSubview(collectionView)
        } else {
            view.addSubview(placeholderImageView)
            view.addSubview(placeholderTitleLabel)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            navBarItem.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navBarItem.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBarItem.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.leadingAnchor.constraint(equalTo: navBarItem.leadingAnchor, constant: 6),
            plusButton.topAnchor.constraint(equalTo: navBarItem.topAnchor),
            plusButton.bottomAnchor.constraint(equalTo: navBarItem.bottomAnchor),
            
            datePicker.topAnchor.constraint(equalTo: navBarItem.topAnchor, constant: 4),
            datePicker.trailingAnchor.constraint(equalTo: navBarItem.trailingAnchor, constant: -16),
            datePicker.bottomAnchor.constraint(equalTo: navBarItem.bottomAnchor, constant: 4),
            
            titleLabel.leadingAnchor.constraint(equalTo: plusButton.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: plusButton.bottomAnchor, constant: 1),
            
            searchTextField.heightAnchor.constraint(equalToConstant: 36),
            searchTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 7),
            searchTextField.trailingAnchor.constraint(equalTo: datePicker.trailingAnchor),
            
//            collectionView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
//            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
//            collectionView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
//            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
//            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
//            placeholderImageView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 230),
//            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//
//            placeholderTitleLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
//            placeholderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        if categories.count != 0 {
            NSLayoutConstraint.activate([
                collectionView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
                collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
                collectionView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
                placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
                placeholderImageView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 230),
                placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                placeholderTitleLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
                placeholderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
    }

}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TreckersCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! TreckersCollectionViewCell
        
        let tracker = categories[indexPath.section].trackers[indexPath.row]
        cell.configure(with: tracker)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TrackersViewController: UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categories.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 4.5, height: 148)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerHeaderCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! TrackerHeaderCollectionViewCell
        let category = categories[indexPath.section]
        headerView.configure(header: category.title)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 18)
    }

}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    // Реализация методов UITextFieldDelegate, если необходимо
}

// MARK: - CreatingTrackerViewControllerDelegate

extension TrackersViewController: CreatingTrackerViewControllerDelegate {
    func createTrackers(nameCategory: String, schedule: [WeekDay], nameTracker: String, color: UIColor, emoji: String) {
        var updatedCategories = categories
        
        
        if let existingCategoryIndex = updatedCategories.firstIndex(where: { $0.title == nameCategory }) {
                let newTracker = Tracker(id: UUID(), name: nameTracker, color: color, emoji: emoji, schedule: schedule)
                let updatedTrackers = updatedCategories[existingCategoryIndex].trackers + [newTracker]
                let updatedCategory = TrackerCategory(title: nameCategory, trackers: updatedTrackers)
                updatedCategories[existingCategoryIndex] = updatedCategory
        } else {
            let newTracker = Tracker(id: UUID(), name: nameTracker, color: color, emoji: emoji, schedule: schedule)
            let newCategory = TrackerCategory(title: nameCategory, trackers: [newTracker])
            updatedCategories.append(newCategory)
        }
        DataManager.shared.updateTrackerCategory(updatedCategories: updatedCategories)
        
        collectionView.reloadData()
//        return updatedCategories
    }
}
