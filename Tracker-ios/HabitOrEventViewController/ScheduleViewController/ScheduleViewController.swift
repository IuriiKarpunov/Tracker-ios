//
//  ScheduleViewController.swift
//  Tracker-ios
//
//  Created by Iurii on 16.10.23.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    // MARK: - Stored properties
    
    private var schedule = [WeekDay]()
    weak var delegate: ScheduleViewControllerDelegate?
    var selectedSchedule = [WeekDay]()
    //MARK: - Layout variables
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("schedule", comment: "Schedule")
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 75
        tableView.layer.cornerRadius = 16
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var addScheduleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(NSLocalizedString("ready", comment: "Ready"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.ypWhiteDay, for: .normal)
        button.accessibilityIdentifier = "addScheduleButton"
        button.layer.cornerRadius = 16
        button.addTarget(
            self,
            action: #selector(didTapAddScheduleButton),
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
        tableView.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.reuseIdentifier)
        addSubViews()
        applyConstraints()
        schedule = selectedSchedule
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapAddScheduleButton() {
        guard let delegate = delegate else { return }
        delegate.createSchedule(schedule: schedule)
        dismiss(animated: true)
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(addScheduleButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 21),
            
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(WeekDay.allCases.count * 75)),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(lessThanOrEqualTo: addScheduleButton.topAnchor, constant: -47),
            
            addScheduleButton.heightAnchor.constraint(equalToConstant: 60),
            addScheduleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addScheduleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addScheduleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}

// MARK: - ScheduleCellDelegate

extension ScheduleViewController: ScheduleCellDelegate {
    func switchStateChanged(weekDay: WeekDay, isOn: Bool) {
        if isOn {
            schedule.append(weekDay)
        } else {
            if let index = schedule.firstIndex(of: weekDay) {
                schedule.remove(at: index)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.reuseIdentifier, for: indexPath)
        
        guard let scheduleCell = cell as? ScheduleCell else {
            return UITableViewCell()
        }
        
        scheduleCell.delegate = self
        
        scheduleCell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        if indexPath.row == WeekDay.allCases.count - 1 {
            scheduleCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        }
        let currentWeekDay = WeekDay.allCases[indexPath.row]
        let isSelected = selectedSchedule.contains(currentWeekDay)
        scheduleCell.configureCell(weekDay: currentWeekDay, isSelected: isSelected)
        
        return scheduleCell
    }
}
