//
//  NewHabitViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 11.10.23.
//


import UIKit

final class NewHabitOrEventViewController: UIViewController {
    
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
    
    // MARK: - Private Properties
    
    private var selectedEmojiIndex: Int?
    private var selectedColorIndex: Int?
    private var selectedEmoji: String?
    private var selectedColor: UIColor?
    private var category: TrackerCategory?
    private var schedule = [WeekDay]()
    
    // MARK: - Private Constants
    
    private let trackerStore = TrackerStore.shared
    private let trackerCategoryStore = TrackerCategoryStore.shared
    
    private let emoji: [String] = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let color: [UIColor] = [
        .ypColorSelection1, .ypColorSelection2, .ypColorSelection3, .ypColorSelection4, .ypColorSelection5,
        .ypColorSelection6, .ypColorSelection7, .ypColorSelection8, .ypColorSelection9, .ypColorSelection10,
        .ypColorSelection11, .ypColorSelection12, .ypColorSelection13, .ypColorSelection14, .ypColorSelection15,
        .ypColorSelection16, .ypColorSelection17, .ypColorSelection18
    ]
    
    private let emojiSectionHeaderTitle = "Emoji"
    private let colorSectionHeaderTitle = NSLocalizedString("color", comment: "Color")
    
    //MARK: - Layout variables
    
    private lazy var newHabitTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = NSLocalizedString("enterTrackerName", comment: "Enter tracker name")
        textField.addLeftPadding(16)
        textField.backgroundColor = .ypBackgroundDay
        textField.layer.cornerRadius = 16
        textField.delegate = self
        
        return textField
    }()
    
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Chevron.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var scheduleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Chevron.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.accessibilityIdentifier = "categoryButton"
        button.setTitle(NSLocalizedString("category", comment: "Category"), for: .normal)
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
    
    private lazy var headerCategoryLabel: UILabel = {
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
        button.setTitle(NSLocalizedString("schedule", comment: "Schedule"), for: .normal)
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
    
    private lazy var headerScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .ypGrey
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(
            EmojiAndColorHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiAndColorHeaderView.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(
            EmojiAndColorHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: EmojiAndColorHeaderView.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("cancel", comment: "Cancel"), for: .normal)
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
        button.setTitle(NSLocalizedString("create", comment: "Create"), for: .normal)
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
    
    private lazy var delimiterView: UIView = {
        let delimiterView = UIView()
        delimiterView.backgroundColor = .ypGrey
        delimiterView.translatesAutoresizingMaskIntoConstraints = false
        return delimiterView
    }()
    
    private lazy var errorTitleLabel: UILabel = {
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
        
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        addSubViews()
        creatHabitOrEvent()
        applyConstraints()
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapCategoryButton() {
        let categoryName = headerCategoryLabel.text
        let categoryViewController = CategoryViewController()
        
        categoryViewController.selectedCategoryName = categoryName
        categoryViewController.delegate = self
        present(categoryViewController, animated: true)
    }
    
    @objc
    private func didTapScheduleButton() {
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        present(scheduleViewController, animated: true)
        textField.resignFirstResponder()
    }
    
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        let newSchedule: [WeekDay]
        
        if habitOrEvent == .habit {
            newSchedule = schedule
        } else {
            newSchedule = WeekDay.allCases
        }
        
        let newTracker = Tracker(
            id: UUID(),
            name: textField.text ?? NSLocalizedString("untitled", comment: "Untitled"),
            color: selectedColor ?? .ypColorSelection1,
            emoji: selectedEmoji ?? "",
            schedule: newSchedule
        )
        delegate?.createTrackers(
            tracker: newTracker,
            categoryName: headerCategoryLabel.text ?? NSLocalizedString("newCategory", comment: "New category")
        )
        
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        window.rootViewController = TabBarController()
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(newHabitTitleLabel)
        view.addSubview(scrollView)
        scrollView.addSubview(textField)
        scrollView.addSubview(errorTitleLabel)
        scrollView.addSubview(categoryButton)
        categoryButton.addSubview(categoryImageView)
        categoryButton.addSubview(headerCategoryLabel)
        scrollView.addSubview(emojiCollectionView)
        scrollView.addSubview(colorCollectionView)
        scrollView.addSubview(cancelButton)
        scrollView.addSubview(createButton)
        
        if habitOrEvent == .habit {
            scrollView.addSubview(scheduleButton)
            scheduleButton.addSubview(scheduleImageView)
            scheduleButton.addSubview(headerScheduleLabel)
            scheduleButton.addSubview(delimiterView)
        }
    }
    
    private func creatHabitOrEvent() {
        switch habitOrEvent {
        case .habit:
            newHabitTitleLabel.text = NSLocalizedString("newHabit", comment: "New habit")
            categoryButton.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            break
        case .event:
            newHabitTitleLabel.text = NSLocalizedString("newIrregularEvent", comment: "New irregular event")
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
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: newHabitTitleLabel.bottomAnchor, constant: 38),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            errorTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorTitleLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            
            categoryButton.heightAnchor.constraint(equalToConstant: 75),
            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryButton.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor, constant: 24),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryImageView.heightAnchor.constraint(equalToConstant: 24),
            categoryImageView.widthAnchor.constraint(equalToConstant: 24),
            categoryImageView.centerYAnchor.constraint(equalTo: categoryButton.centerYAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: categoryButton.trailingAnchor, constant: -16),
            
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: 166),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.trailingAnchor.constraint(equalTo: createButton.leadingAnchor, constant: -8),
            cancelButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.widthAnchor.constraint(equalToConstant: 166),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
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
                scheduleImageView.trailingAnchor.constraint(equalTo: scheduleButton.trailingAnchor, constant: -16),
                
                emojiCollectionView.heightAnchor.constraint(equalToConstant: 199),
                emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
                emojiCollectionView.topAnchor.constraint(equalTo: scheduleButton.bottomAnchor, constant: 32),
                emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
                
                colorCollectionView.heightAnchor.constraint(equalToConstant: 199),
                colorCollectionView.leadingAnchor.constraint(equalTo: emojiCollectionView.leadingAnchor),
                colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
                colorCollectionView.trailingAnchor.constraint(equalTo: emojiCollectionView.trailingAnchor),
                colorCollectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -46)
            ])
        } else {
            NSLayoutConstraint.activate([
                emojiCollectionView.heightAnchor.constraint(equalToConstant: 199),
                emojiCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
                emojiCollectionView.topAnchor.constraint(equalTo: categoryButton.bottomAnchor, constant: 32),
                emojiCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
                
                colorCollectionView.heightAnchor.constraint(equalToConstant: 199),
                colorCollectionView.leadingAnchor.constraint(equalTo: emojiCollectionView.leadingAnchor),
                colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 40),
                colorCollectionView.trailingAnchor.constraint(equalTo: emojiCollectionView.trailingAnchor),
                colorCollectionView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -46)
            ])
        }
    }
    
    private func addButton() {
        let isHabitButton = habitOrEvent == .habit
        let isValidSchedule = isHabitButton ? (headerScheduleLabel.text != "") : true
        let isValidText = textField.text != ""
        let isValidCategory = headerCategoryLabel.text != ""
        let isEmoji = selectedEmoji != nil
        let isColor = selectedColor != nil
        
        createButton.isEnabled = isValidSchedule && isValidText && isValidCategory && isEmoji && isColor
        createButton.backgroundColor = createButton.isEnabled ? .ypBlackDay : .ypGrey
    }
}

// MARK: - UICollectionViewDataSource

extension NewHabitOrEventViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == emojiCollectionView {
            return emoji.count
        } else if collectionView == colorCollectionView {
            return color.count
        }
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as! EmojiCell
            cell.configure(emoji: emoji[indexPath.item], isSelected: indexPath.item == selectedEmojiIndex)
            return cell
        } else if collectionView == colorCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as! ColorCell
            cell.configure(color: color[indexPath.item], isSelected: indexPath.item == selectedColorIndex)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension NewHabitOrEventViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            selectedEmojiIndex = indexPath.item
            self.selectedEmoji = emoji[indexPath.item]
            emojiCollectionView.reloadData()
        } else if collectionView == colorCollectionView {
            selectedColorIndex = indexPath.item
            self.selectedColor = color[indexPath.item]
            colorCollectionView.reloadData()
        }
        addButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EmojiAndColorHeaderView.reuseIdentifier, for: indexPath) as! EmojiAndColorHeaderView
            if collectionView == emojiCollectionView {
                headerView.titleLabel.text = emojiSectionHeaderTitle
            } else if collectionView == colorCollectionView {
                headerView.titleLabel.text = colorSectionHeaderTitle
            }
            return headerView
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 43)
    }
}

//MARK: - UITextFieldDelegate

extension NewHabitOrEventViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            let currentText = textField.text ?? ""
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
            
            if updatedText.count > 38 {
                errorTitleLabel.text = NSLocalizedString("limit38characters", comment: "Limit 38 characters")
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
        let sortedSchedule = schedule.sorted { (firstDay, secondDay) -> Bool in
            return firstDay.rawValue < secondDay.rawValue
        }
        
        let filteredAndSortedSchedule = WeekDay.allCases.filter { sortedSchedule.contains($0) }
        
        self.schedule = filteredAndSortedSchedule
        headerScheduleLabel.text = filteredAndSortedSchedule.map { $0.shortName }.joined(separator: ", ")
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
