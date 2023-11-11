//
//  NewHabitOrEventViewCell.swift
//  Tracker-ios
//
//  Created by Iurii on 02.11.23.
//

import UIKit

final class EmojiCell: UICollectionViewCell {
    
    // MARK: - Stored Properties
    
    static let reuseIdentifier = "EmojiCell"
    
    //MARK: - Layout variables
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 16
        label.clipsToBounds = true
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
    
    func configure(emoji: String, isSelected: Bool) {
        emojiLabel.text = emoji
        contentView.layer.cornerRadius = 16
        contentView.backgroundColor = isSelected ? .ypLightGray : .clear
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        contentView.addSubview(emojiLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
