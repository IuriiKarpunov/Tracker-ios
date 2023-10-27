//
//  NewHabitViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 11.10.23.
//


import UIKit

final class NewHabitOrEventViewController: UIViewController {
    
    private var category: TrackerCategory?
    private var schedule = [WeekDay]()
    weak var delegate: NewHabitOrEventViewControllerDelegate?
    
    enum HabitOrEvent {
        case habit
        case event
    }
    
    var habitOrEvent: HabitOrEvent
    
    init(habitOrEvent: HabitOrEvent) {
        self.habitOrEvent = habitOrEvent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout variables
    
    private let newHabitTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var textField: UITextField = {
        textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Введите название трекера"
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.borderStyle = .roundedRect
        textField.delegate = self
        
        return textField
    }()
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Chevron.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let scheduleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Chevron.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = "categoryButton"
        button.setTitle("Категория", for: .normal)
        button.setTitleColor(.ypBlackDay, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.contentHorizontalAlignment = .left
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = .ypBackgroundDay
        button.addTarget(
            self,
            action: #selector(didTapCategoryButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let headerCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .ypGrey
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = "scheduleButton"
        button.setTitle("Расписание", for: .normal)
        button.setTitleColor(.ypBlackDay, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        button.titleLabel?.font = .systemFont(ofSize: 17)
        button.contentHorizontalAlignment = .left
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        button.backgroundColor = .ypBackgroundDay
        button.addTarget(
            self,
            action: #selector(didTapScheduleButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let headerScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .ypGrey
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.accessibilityIdentifier = "cancelButton"
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor
        button.backgroundColor = .clear
        button.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Создать", for: .normal)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.accessibilityIdentifier = "createButton"
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapCreateButton),
            for: .touchUpInside
        )
        button.backgroundColor = .ypGrey
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let delimiterView: UIView = {
        let delimiterView = UIView()
        delimiterView.backgroundColor = .ypGrey
        delimiterView.translatesAutoresizingMaskIntoConstraints = false
        return delimiterView
    }()
    
    private let errorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypRed
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhiteDay
        addSubViews()
        creatHabitOrEvent()
        applyConstraints()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapCategoryButton() {
        let categoryViewController = CategoryViewController()
        categoryViewController.delegate = self
        present(categoryViewController, animated: true)
    }
    
    @objc
    private func didTapScheduleButton() {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        present(scheduleViewController, animated: true)
    }
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        delegate?.createTrackers(
            nameCategory: headerCategoryLabel.text ?? "Новая категория",
            schedule: schedule,
            nameTracker: textField.text ?? "Без названия",
            color: .brown,
            emoji: "🫠"
        )
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = TrackersViewController()
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(newHabitTitleLabel)
        view.addSubview(scrollView)
        view.addSubview(textField)
        view.addSubview(errorTitleLabel)
        view.addSubview(categoryImageView)
        view.addSubview(categoryButton)
        view.addSubview(headerCategoryLabel)
        view.addSubview(cancelButton)
        view.addSubview(createButton)
        
        if habitOrEvent == .habit {
            view.addSubview(scheduleImageView)
            view.addSubview(scheduleButton)
            view.addSubview(headerScheduleLabel)
            view.addSubview(delimiterView)
        }
    }
    
    private func creatHabitOrEvent() {
        switch habitOrEvent {
        case .habit:
            newHabitTitleLabel.text = "Новая привычка"
            categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            break
        case .event:
            newHabitTitleLabel.text = "Новое нерегулярное событие"
            break
        }
    }
    
    private func headerCategoryUpdate() {
        if headerCategoryLabel.text == "" {
            scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        } else {
            categoryButton.titleEdgeInsets = UIEdgeInsets(top: -15, left: 16, bottom: 0, right: 0)
            NSLayoutConstraint.activate([
                headerCategoryLabel.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor, constant: 16),
                headerCategoryLabel.bottomAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: -14),
                headerCategoryLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        }
    }
    
    private func headerScheduleUpdate() {
        if headerScheduleLabel.text == "" {
            scheduleButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        } else {
            scheduleButton.titleEdgeInsets = UIEdgeInsets(top: -15, left: 16, bottom: 0, right: 0)
            NSLayoutConstraint.activate([
                headerScheduleLabel.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
                headerScheduleLabel.bottomAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: -14),
                headerScheduleLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        }
    }
    
    private func applyConstraints() {
            NSLayoutConstraint.activate([
                newHabitTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                newHabitTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 21),
                
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                scrollView.topAnchor.constraint(equalTo: newHabitTitleLabel.bottomAnchor, constant: 38),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                scrollView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: 16),
                
                textField.heightAnchor.constraint(equalToConstant: 75),
                textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
                textField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                
                errorTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                errorTitleLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
                
                categoryButton.heightAnchor.constraint(equalToConstant: 75),
                categoryButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                categoryButton.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 24),
                categoryButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
                
                categoryImageView.heightAnchor.constraint(equalToConstant: 24),
                categoryImageView.widthAnchor.constraint(equalToConstant: 24),
                categoryImageView.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
                categoryImageView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
                
                cancelButton.heightAnchor.constraint(equalToConstant: 60),
                cancelButton.widthAnchor.constraint(equalToConstant: 166),
                cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                createButton.heightAnchor.constraint(equalToConstant: 60),
                cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
                cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                
                createButton.widthAnchor.constraint(equalToConstant: 166),
                createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        
        if habitOrEvent == .habit {
            NSLayoutConstraint.activate([
            scheduleButton.heightAnchor.constraint(equalToConstant: 75),
            scheduleButton.leadingAnchor.constraint(equalTo: categoryButton.leadingAnchor),
            scheduleButton.topAnchor.constraint(equalTo: categoryButton.bottomAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor),
            
            delimiterView.centerXAnchor.constraint(equalTo: scheduleButton.centerXAnchor),
            delimiterView.leadingAnchor.constraint(equalTo: scheduleButton.leadingAnchor, constant: 16),
            delimiterView.topAnchor.constraint(equalTo: scheduleButton.topAnchor),
            delimiterView.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
            delimiterView.heightAnchor.constraint(equalToConstant: 0.5),
            
            scheduleImageView.heightAnchor.constraint(equalToConstant: 24),
            scheduleImageView.widthAnchor.constraint(equalToConstant: 24),
            scheduleImageView.centerYAnchor.constraint(equalTo: scheduleButton.centerYAnchor),
            scheduleImageView.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16)
            ])
        }
    }
    
    private func addButton() {
        let isHabitButton = habitOrEvent == .habit
        let isValidSchedule = isHabitButton ? (headerScheduleLabel.text != "") : true
        let isValidText = textField.text != ""
        let isValidCategory = headerCategoryLabel.text != ""
        
        createButton.isEnabled = isValidSchedule && isValidText && isValidCategory
        createButton.backgroundColor = createButton.isEnabled ? .ypBlackDay : .ypGrey
    }
}

//MARK: - UITextFieldDelegate

extension NewHabitOrEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if updatedText.count > 38 {
                errorTitleLabel.text = "Ограничение 38 символов"
                return false
            } else {
                errorTitleLabel.text = ""
                return true
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addButton()
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - ScheduleViewControllerDelegate

extension NewHabitOrEventViewController: ScheduleViewControllerDelegate {
    func createSchedule(schedule: [WeekDay]) {
        self.schedule = schedule
        headerScheduleLabel.text = schedule.map { $0.shortName }.joined(separator: ", ")
        headerScheduleUpdate()
        addButton()
    }
}

//MARK: - CategoryViewControllerDelegate

extension NewHabitOrEventViewController: CategoryViewControllerDelegate {
    func updateCategory(category: String) {
        headerCategoryLabel.text = category
        headerCategoryUpdate()
        addButton()
    }
}
