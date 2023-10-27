//
//  TreckersCollectionViewCell.swift
//  Tracker-ios
//
//  Created by Iurii on 23.10.23.
//

import UIKit

final class TreckersCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ScheduleCell"
    private var trackerID: UUID?
    weak var delegate: TreckersCollectionViewCellDelegate?
    //MARK: - Layout variables
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhiteDay
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
       
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.backgroundColor = .ypWhiteDay.withAlphaComponent(0.3)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 16
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
    }()
    
    private let daysLabel: UILabel = {
        let label = UILabel()
        label.text = "0 дней"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var executeButton: UIButton = {
        let button = UIButton(type: .custom)
        let image = UIImage(named: "plusCellButton.png")
        button.accessibilityIdentifier = "executeButton"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with tracker: Tracker) {
        nameLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        colorView.backgroundColor = tracker.color
        trackerID = tracker.id
    }
    
    func updateButtonImage() {
        if let currentImage = executeButton.currentImage {
            let currentImageName = (currentImage == UIImage(named: "plusCellButton.png")) ? "executeCellButton.png" : "plusCellButton.png"
            let newImage = UIImage(named: currentImageName)
            executeButton.setImage(newImage, for: .normal)
        }
    }
    
    // MARK: - IBAction
    
    @objc
    private func didTapPlusButton() {
        guard let trackerID = trackerID else {
            return
        }
        delegate?.updateCompletedTrackers(trackerID: trackerID)
        updateButtonImage()
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        contentView.addSubview(colorView)
        colorView.addSubview(emojiLabel)
        colorView.addSubview(nameLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(executeButton)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 90),
            colorView.widthAnchor.constraint(equalToConstant: 167),
            colorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            colorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            emojiLabel.heightAnchor.constraint(equalToConstant: 24),
            emojiLabel.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            emojiLabel.topAnchor.constraint(equalTo: colorView.topAnchor, constant: 12),
            
            nameLabel.leadingAnchor.constraint(equalTo: emojiLabel.leadingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: colorView.bottomAnchor, constant: -12),
            nameLabel.trailingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: -12),
            
            daysLabel.leadingAnchor.constraint(equalTo: colorView.leadingAnchor, constant: 12),
            daysLabel.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 16),
            
            executeButton.heightAnchor.constraint(equalToConstant: 34),
            executeButton.widthAnchor.constraint(equalToConstant: 34),
            executeButton.topAnchor.constraint(equalTo: colorView.bottomAnchor, constant: 8),
            executeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
