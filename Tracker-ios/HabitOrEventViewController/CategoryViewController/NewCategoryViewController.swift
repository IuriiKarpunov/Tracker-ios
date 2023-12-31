//
//  NewCategoryViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 14.10.23.
//

import UIKit

final class NewCategoryViewController: UIViewController {
    
    weak var delegate: NewCategoryViewControllerDelegate?
    
    //MARK: - Layout variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("newCategory", comment: "New category")
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = NSLocalizedString("enterCategoryName", comment: "Enter category name")
        textField.addLeftPadding(16)
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var readyButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("ready", comment: "Ready"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.accessibilityIdentifier = "readyButton"
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapReadyButton),
            for: .touchUpInside
        )
        button.backgroundColor = .ypGrey
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addSubViews()
        applyConstraints()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapReadyButton() {
        if let categoryName = textField.text {
            let category = TrackerCategory(title: categoryName, trackers: [])
            delegate?.addNewCategories(category: category)
        }
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        [titleLabel, readyButton, textField].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 21),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 38),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            readyButton.heightAnchor.constraint(equalToConstant: 60),
            readyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

extension NewCategoryViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        
        if newText.count > 0 {
            readyButton.isEnabled = true
            readyButton.backgroundColor = UIColor.ypBlackDay
        } else {
            readyButton.isEnabled = false
            readyButton.backgroundColor = UIColor.ypGrey
        }
        
        return true
    }
}
