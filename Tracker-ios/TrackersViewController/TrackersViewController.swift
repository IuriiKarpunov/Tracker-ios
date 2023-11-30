//
//  ViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 01.10.23.
//

import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - Public Properties
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var visibleCategories: [TrackerCategory] = []
    var currentDate: Date?
    private var currentFilter: Filters? = .allTrackers
    
    // MARK: - Private Constants
    
    private let trackerCategoryStore = TrackerCategoryStore.shared
    private let trackerRecordStore = TrackerRecordStore.shared
    private let trackerStore = TrackerStore.shared
    
    //MARK: - Layout variables
    
    private lazy var navBarItem: UIView = {
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
    
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = Locale.current
        picker.preferredDatePickerStyle = .compact
        picker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        picker.translatesAutoresizingMaskIntoConstraints = false
        
        return picker
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("trackers", comment: "Trackers")
        label.textColor = .ypBlackDay
        label.font = UIFont.boldSystemFont(ofSize: 34)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "titleLabel"
        
        return label
    }()
    
    private lazy var searchTextField: UISearchTextField = {
        let search = UISearchTextField()
        search.placeholder = NSLocalizedString("search", comment: "Search")
        search.borderStyle = .roundedRect
        search.autocorrectionType = .no
        search.autocapitalizationType = .none
        search.clearButtonMode = .whileEditing
        search.delegate = self
        search.translatesAutoresizingMaskIntoConstraints = false
        
        return search
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "No Photo.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private lazy var placeholderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("whatWillWeTrack", comment: "What will we track?")
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "placeholderTitleLabel"
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(
            TreckersCollectionViewCell.self,
            forCellWithReuseIdentifier: TreckersCollectionViewCell.reuseIdentifier
        )
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 66, right: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("filters", comment: "Filters"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapFiltersButton),
            for: .touchUpInside
        )
        button.backgroundColor = .ypBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadData()
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
        
        do {
            completedTrackers = try trackerRecordStore.fetchTrackersRecord()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapPlusButton() {
        let creatingTrackerViewController = CreatingTrackerViewController()
        creatingTrackerViewController.delegate = self
        present(creatingTrackerViewController, animated: true)
    }
    
    @objc
    private func dateChanged() {
        if currentFilter == .todayTrackers,
           !Calendar.current.isDate(datePicker.date, inSameDayAs: Date()) {
            currentFilter = .allTrackers
            filtersButton.setTitleColor(.white, for: .normal)
        }
        reloadvisibleCategories(text: searchTextField.text, date: datePicker.date)
    }
    
    @objc
    private func didTapFiltersButton() {
        let filtersViewController = FiltersViewController()
        filtersViewController.delegate = self
        filtersViewController.selectedFilters = currentFilter
        present(filtersViewController, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(navBarItem)
        view.addSubview(plusButton)
        view.addSubview(titleLabel)
        view.addSubview(datePicker)
        view.addSubview(searchTextField)
        view.addSubview(collectionView)
        view.addSubview(placeholderImageView)
        view.addSubview(placeholderTitleLabel)
        view.addSubview(filtersButton)
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
            
            collectionView.leadingAnchor.constraint(equalTo: searchTextField.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 18),
            collectionView.trailingAnchor.constraint(equalTo: searchTextField.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            placeholderImageView.heightAnchor.constraint(equalToConstant: 80),
            placeholderImageView.widthAnchor.constraint(equalToConstant: 80),
            placeholderImageView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 230),
            placeholderImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            placeholderTitleLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 8),
            placeholderTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func reloadData() {
        categories = []
        var pinnedTrackers: [Tracker] = []

        for category in trackerCategoryStore.trackerCategory {
            let trackers = category.trackers

            let pinnedTrackersForCategory = trackers.filter { $0.isPinned }
            let unpinnedTrackers = trackers.filter { !$0.isPinned }

            pinnedTrackers.append(contentsOf: pinnedTrackersForCategory)

            if !unpinnedTrackers.isEmpty {
                let unpinnedCategory = TrackerCategory(title: category.title, trackers: unpinnedTrackers)
                categories.append(unpinnedCategory)
            }
        }

        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(title: "Закрепленные", trackers: pinnedTrackers)
            categories.insert(pinnedCategory, at: 0)
        }

        dateChanged()
    }
    
    private func getComletedCount(id: UUID) -> Int {
        var result: Int = 0
        
        completedTrackers.forEach { trackerRecord in
            if trackerRecord.trackerID == id {
                result += 1
            }
        }
        return result
    }
    
    private func reloadvisibleCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filterWeekday = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                let textCondition = filterText.isEmpty ||
                tracker.name.lowercased().contains(filterText)
                let dateCondition = tracker.schedule.contains { weekDay in
                    weekDay.numberOfDay == filterWeekday
                } == true
                
                let isCompletedTracker = completedTrackers.contains { trackerRecord in
                    trackerRecord.trackerID == tracker.id &&
                    calendar.isDate(trackerRecord.date, inSameDayAs: date)
                }

                if currentFilter == .completedTrackers {
                    return textCondition && dateCondition && isCompletedTracker
                } else if currentFilter == .unCompletedTrackers {
                    return textCondition && dateCondition && !isCompletedTracker
                }
                
                return textCondition && dateCondition
            }
            
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        collectionView.reloadData()
        reloadPlaceholder()
    }
    
    private func reloadPlaceholder() {
        if visibleCategories.count == 0 {
            placeholderImageView.isHidden = false
            placeholderTitleLabel.isHidden = false
            filtersButton.isHidden = currentFilter == .allTrackers
        } else {
            placeholderImageView.isHidden = true
            placeholderTitleLabel.isHidden = true
            filtersButton.isHidden = false
        }
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.trackerID  == id && isSameDay
    }
    
    private func showDeleteAlert(forItemAt indexPath: IndexPath) {
        let alertController = UIAlertController(
            title: "Уверены что хотите удалить трекер?",
            message: nil,
            preferredStyle: .actionSheet
        )

        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.handleDeleteTracker(at: indexPath)
        }
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)

        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func handleDeleteTracker(at indexPath: IndexPath) {
        let trackerID = visibleCategories[indexPath.section].trackers[indexPath.row].id
        
        do {
            try trackerStore.deleteTracker(withID: trackerID)
            try trackerRecordStore.deleteTrackerRecordAll(withID: trackerID)
            reloadData()
        } catch {
            fatalError("Error deleting tracker: \(error)")
        }
    }
    
    private func applyFilter(_ filter: Filters) {
        currentFilter = filter
        
        if currentFilter != .allTrackers {
                filtersButton.setTitleColor(.ypRed, for: .normal)
            } else {
                filtersButton.setTitleColor(.white, for: .normal)
            }
        
        switch filter {
        case .todayTrackers:
            datePicker.date = Date()
        default:
            break
        }
        dateChanged()
    }
}

// MARK: - UICollectionViewDataSource

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TreckersCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! TreckersCollectionViewCell
        
        cell.delegate = self
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            indexPath: indexPath,
            daysCount: getComletedCount(id: tracker.id),
            selectedDate: datePicker.date,
            isPinned: tracker.isPinned
        )
        return cell
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension TrackersViewController: UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration
    ) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) as? TreckersCollectionViewCell
        else {
            return nil
        }

        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        return UITargetedPreview(view: cell.colorView, parameters: parameters)
    }

    
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil,
            actionProvider: { [weak self] _ -> UIMenu? in
                guard let self = self else { return nil }
                
                let tracker = self.visibleCategories[indexPath.section].trackers[indexPath.row]
                return UIMenu(children: [
                    UIAction(title: tracker.isPinned ? "Открепить" : "Закрепить") { [weak self] _ in
                        guard let self = self else { return }
                        let trackerID = tracker.id
                        do {
                            try self.trackerStore.toggleTrackerPinnedState(withID: trackerID)
                            reloadData()
                        } catch {
                            print("Ошибка при изменении состояния isPinned: \(error.localizedDescription)")
                        }
                    },
                    UIAction(title: "Редактировать") { [weak self] _ in
                        guard let self = self else { return }
                        let trackerID = tracker.id
                        let categorie = visibleCategories[indexPath.section].title
                        let newHabitOrEventViewController = NewHabitOrEventViewController(habitOrEvent: .edit)
                        
                        newHabitOrEventViewController.delegate = self
                        newHabitOrEventViewController.daysCount = getComletedCount(id: trackerID)
                        newHabitOrEventViewController.trackerID = trackerID
                        newHabitOrEventViewController.editCategorie = categorie
                        self.present(newHabitOrEventViewController, animated: true)
                    },
                    UIAction(title: "Удалить", attributes: [.destructive]) { [weak self] _ in
                        self?.showDeleteAlert(forItemAt: indexPath)
                    },
                ])
            })
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
        let category = visibleCategories[indexPath.section]
        headerView.configure(header: category.title)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
}

// MARK: - UITextFieldDelegate

extension TrackersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        reloadvisibleCategories(text: searchTextField.text, date: datePicker.date)
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
        reloadvisibleCategories(text: searchText, date: datePicker.date)
        return true
    }
}

// MARK: - CreatingTrackerViewControllerDelegate & NewHabitOrEventViewControllerDelegate

extension TrackersViewController: CreatingTrackerViewControllerDelegate, NewHabitOrEventViewControllerDelegate {
    func createTrackers(tracker: Tracker, categoryName: String) {
        createOrUpdateTrackers(tracker: tracker, categoryName: categoryName)
    }

    func createTrackersHabit(tracker: Tracker, categoryName: String) {
        createOrUpdateTrackers(tracker: tracker, categoryName: categoryName)
    }
    
    private func createOrUpdateTrackers(tracker: Tracker, categoryName: String) {
        categories = trackerCategoryStore.trackerCategory
        dateChanged()
        guard let index = categories.firstIndex(where: { $0.title == categoryName }) else {
            return
        }
        
        let updatedCategory = categories[index]
        do {
            try trackerCategoryStore.addTracker(tracker, to: updatedCategory)
            collectionView.reloadData()
        } catch {
            print("Error adding tracker to existing category: \(error)")
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate

extension TrackersViewController: TrackerCategoryStoreDelegate {
    func store(_ store: TrackerCategoryStore, didUpdate update: TrackerCategoryStoreUpdate) {
        collectionView.reloadData()
    }
}

// MARK: - TreckersCollectionViewCellDelegate

extension TrackersViewController: TreckersCollectionViewCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        let trackerRecord = TrackerRecord(trackerID: id, date: datePicker.date)
        completedTrackers.append (trackerRecord)
        try? trackerRecordStore.addNewTrackerRecord(TrackerRecord(trackerID: id, date: datePicker.date))
        collectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        try? trackerRecordStore.deleteTrackerRecord(TrackerRecord(trackerID: id, date: datePicker.date))
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - FiltersViewControllerDelegate

extension TrackersViewController: FiltersViewControllerDelegate {
    func filtersViewController(_ controller: FiltersViewController, didSelectFilter filter: Filters) {
        applyFilter(filter)
    }
}
