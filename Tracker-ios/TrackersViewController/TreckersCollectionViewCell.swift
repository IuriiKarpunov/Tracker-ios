//
//  TreckersCollectionViewCell.swift
//  Tracker-ios
//
//  Created by Iurii on 23.10.23.
//

import UIKit

final class TreckersCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Stored Properties
    
    
    static let reuseIdentifier = "TreckersCollectionViewCell"
    private let analyticsService = AnalyticsService()
    
    private var isCompletedToday: Bool = false
    private var trackerID: UUID?
    private var indexPath: IndexPath?
    private var selectedDate: Date?
    weak var delegate: TreckersCollectionViewCellDelegate?
    
    //MARK: - Layout variables
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhiteDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = .ypWhiteDay.withAlphaComponent(0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
     lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 16
        colorView.translatesAutoresizingMaskIntoConstraints = false
         
        return colorView
    }()
    
    private lazy var daysLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var executeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 17
        button.addTarget(
            self,
            action: #selector(didTapPlusButton),
            for: .touchUpInside
        )
        button.tintColor = .ypWhiteDay
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var pinnedImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Pinned.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = false
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with tracker: Tracker, isCompletedToday: Bool, indexPath: IndexPath, daysCount: Int, selectedDate: Date, isPinned: Bool) {
        nameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        colorView.backgroundColor = tracker.color
        executeButton.backgroundColor = tracker.color
        pinnedImageView.isHidden = !isPinned
        
        self.trackerID = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        self.selectedDate = selectedDate
        
        updateButtonImage(isCompletedToday)
        daysLabel.text = getLocalizedDaysString(daysCount: daysCount)
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapPlusButton() {
        analyticsService.report(event: "click", params: ["screen" : "Main", "item" : "track"])
        
        guard let trackerID = trackerID,
              let indexPath = indexPath,
              let selectedDate = selectedDate else {
            assertionFailure("no trackerId")
            return
        }
        
        if selectedDate > Date() {
            return
        }
        
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerID, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerID, at: indexPath)
        }
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        contentView.addSubview(colorView)
        colorView.addSubview(emojiLabel)
        colorView.addSubview(nameLabel)
        colorView.addSubview(pinnedImageView)
        contentView.addSubview(daysLabel)
        contentView.addSubview(executeButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 90),
            colorView.widthAnchor.constraint(equalToConstant: 167),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            
            pinnedImageView.heightAnchor.constraint(equalToConstant: 24),
            pinnedImageView.widthAnchor.constraint(equalToConstant: 24),
            pinnedImageView.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            pinnedImageView.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -4),
            
            daysLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            daysLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            
            executeButton.heightAnchor.constraint(equalToConstant: 34),
            executeButton.widthAnchor.constraint(equalToConstant: 34),
            executeButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            executeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func updateButtonImage(_ isCompleted: Bool) {
        executeButton.alpha = isCompleted ? 0.3 : 1
        let imageName = isCompleted ? "checkmark" : "plus"
        let image = UIImage(systemName: imageName)
        executeButton.setImage(image, for: .normal)
    }
    
    private func getLocalizedDaysString(daysCount: Int) -> String {
        let localizedFormat = NSLocalizedString("daysString", comment: "")
        return String.localizedStringWithFormat(localizedFormat, daysCount)
    }
}
