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
        imageView.frame = bounds
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(imageView)
        sendSubviewToBack(imageView)
    }
}
