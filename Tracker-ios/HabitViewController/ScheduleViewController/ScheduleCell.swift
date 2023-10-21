//
//  ScheduleCell.swift
//  Tracker-ios
//
//  Created by Iurii on 16.10.23.
//


import UIKit

final class ScheduleCell: UITableViewCell {
    
    // MARK: - Stored properties
    
    weak var delegate: ScheduleCellDelegate?
    var weekDay: WeekDay?
    static let reuseIdentifier = "ScheduleCell"
    
    //MARK: - Layout variables
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var switcherView: UISwitch = {
        let switcher = UISwitch()
        switcher.setOn(false, animated: true)
        switcher.onTintColor = .ypBlue
        switcher.addTarget(self, action: #selector(switchChanged(sender:)), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        
        return switcher
    }()
    
    // MARK: - Lifecycle
    
    func configureCell(weekDay: WeekDay) {
        cellLabel.text = weekDay.rawValue
        contentView.backgroundColor = .ypBackgroundDay
        addSubViews()
        applyConstraints()
    }
    
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        contentView.addSubview(cellLabel)
        contentView.addSubview(switcherView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            switcherView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            switcherView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - IBAction
    
    @objc func switchChanged(sender: UISwitch) {
        guard let weekDay,
              let delegate else { return }
        delegate.switchStateChanged(weekDay: weekDay, isOn: sender.isOn)
    }
}
