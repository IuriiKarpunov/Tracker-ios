//
//  CategoryCell.swift
//  Tracker-ios
//
//  Created by Iurii on 19.10.23.
//

import UIKit

final class CategoryCell: UITableViewCell {
    
    // MARK: - Stored properties
    
    static let reuseIdentifier = "CategoryCell"
    
    //MARK: - Layout variables
    
    private let cellLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlackDay
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let propertyImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "PropertyDone.png"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    func configureCell(category: String) {
        cellLabel.text = category
        contentView.backgroundColor = .ypBackgroundDay
        addSubViews()
        applyConstraints()
    }
    
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        contentView.addSubview(cellLabel)
        contentView.addSubview(propertyImageView)
    }
    
    func turnOnPropertyImageView() {
        if propertyImageView.isHidden == true {
            propertyImageView.isHidden = false
        } else {
            propertyImageView.isHidden = true
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            propertyImageView.heightAnchor.constraint(equalToConstant: 24),
            propertyImageView.widthAnchor.constraint(equalToConstant: 24),
            propertyImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            propertyImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
        
}