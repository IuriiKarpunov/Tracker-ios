//
//  TrackerHeaderCollectionView.swift
//  Tracker-ios
//
//  Created by Iurii on 25.10.23.
//

import UIKit

final class TrackerHeaderCollectionViewCell: UICollectionReusableView {
    
    static let reuseIdentifier = "TrackerHeaderCollectionViewCell"
    
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
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
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
