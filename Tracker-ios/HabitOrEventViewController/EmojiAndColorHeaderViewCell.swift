//
//  EmojiandColorHeaderViewCell.swift
//  Tracker-ios
//
//  Created by Iurii on 05.11.23.
//

import UIKit

final class EmojiAndColorHeaderViewCell: UICollectionReusableView {
    
    static let reuseIdentifier = "EmojiAndColorHeaderViewCell"
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.heightAnchor.constraint(equalToConstant: 18),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            headerLabel.topAnchor.constraint (equalTo: topAnchor, constant: 16),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(header: String) {
        headerLabel.text = header
    }
}
