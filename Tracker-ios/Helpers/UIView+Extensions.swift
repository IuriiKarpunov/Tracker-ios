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
    
    func setGradientBorder() {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = bounds
            gradientLayer.colors = [
                UIColor.red.cgColor,
                UIColor.green.cgColor,
                UIColor.blue.cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

            let shapeLayer = CAShapeLayer()
            shapeLayer.lineWidth = 1.0
            shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
            shapeLayer.fillColor = nil
            shapeLayer.strokeColor = UIColor.black.cgColor
            gradientLayer.mask = shapeLayer

            layer.addSublayer(gradientLayer)
        }
}
