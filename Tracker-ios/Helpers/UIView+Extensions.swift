//
//  UIView+Extensions.swift
//  Tracker-ios
//
//  Created by Iurii on 15.11.23.
//

import UIKit

extension UIView {
    func addBackground(image imageName: String) {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        sendSubviewToBack(imageView)
    }
}
