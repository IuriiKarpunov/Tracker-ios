//
//  ColorCell.swift
//  Tracker-ios
//
//  Created by Iurii on 03.11.23.
//

import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Stored Properties
    
    static let reuseIdentifier = "ColorCell"
    
    //MARK: - Layout variables
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        return colorView
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
    
    func configure(color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        let borderColorWithAlpha = color.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = isSelected ? 3.0 : 0.0
        contentView.layer.borderColor = borderColorWithAlpha.cgColor
    }
    
    // MARK: - Private Methods
    
    private func addSubViews() {
        contentView.addSubview(colorView)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
