//
//  CreatingTrackerViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 11.10.23.
//


import UIKit

final class CreatingTrackerViewController: UIViewController {
    
    //MARK: - Layout variables
    
    private let creatingTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Создание трекера"
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "creatingTitleLabel"
        
        return label
    }()
    
    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.accessibilityIdentifier = "habitButton"
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapHabitButton),
            for: .touchUpInside
        )
        button.backgroundColor = .ypBlackDay
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Нерегулярные событие", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.accessibilityIdentifier = "eventButton"
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapEventButton),
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
        addSubViews()
        applyConstraints()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapHabitButton() {
        let newHabitViewController = UINavigationController(rootViewController: NewHabitViewController(buttonType: .habit))
        present(newHabitViewController, animated: true)
    }
    
    @objc
    private func didTapEventButton() {
        let newHabitViewController = UINavigationController(rootViewController: NewHabitViewController(buttonType: .event))
        present(newHabitViewController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(creatingTitleLabel)
        view.addSubview(habitButton)
        view.addSubview(eventButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            creatingTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            creatingTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 21),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.topAnchor.constraint(equalTo: creatingTitleLabel.bottomAnchor, constant: 295),
            
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.widthAnchor.constraint(equalToConstant: 335),
            eventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16)
        ])
    }
}
