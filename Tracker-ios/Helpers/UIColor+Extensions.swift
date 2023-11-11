//
//  UIColor.swift
//  Tracker-ios
//
//  Created by Iurii on 14.10.23.
//

import UIKit

extension UIColor {
    static var ypBackgroundDay: UIColor! { UIColor(named: "Background [day]")}
    static var ypBackgroundNight: UIColor! { UIColor(named: "Background [night]")}
    static var ypBlackDay: UIColor! { UIColor(named: "Black [day]")}
    static var ypBlackNight: UIColor! { UIColor(named: "Black [night]")}
    static var ypBlue: UIColor! { UIColor(named: "Blue")}
    static var ypGrey: UIColor! { UIColor(named: "Grey")}
    static var ypLightGray: UIColor! { UIColor(named: "Light Gray")}
    static var ypRed: UIColor! { UIColor(named: "Red")}
    static var ypWhiteDay: UIColor! { UIColor(named: "White [day]")}
    static var ypWhiteNight: UIColor! { UIColor(named: "White [night]")}
    
    static var ypColorSelection1: UIColor! { UIColor(named: "Color selection 1")}
    static var ypColorSelection2: UIColor! { UIColor(named: "Color selection 2")}
    static var ypColorSelection3: UIColor! { UIColor(named: "Color selection 3")}
    static var ypColorSelection4: UIColor! { UIColor(named: "Color selection 4")}
    static var ypColorSelection5: UIColor! { UIColor(named: "Color selection 5")}
    static var ypColorSelection6: UIColor! { UIColor(named: "Color selection 6")}
    static var ypColorSelection7: UIColor! { UIColor(named: "Color selection 7")}
    static var ypColorSelection8: UIColor! { UIColor(named: "Color selection 8")}
    static var ypColorSelection9: UIColor! { UIColor(named: "Color selection 9")}
    static var ypColorSelection10: UIColor! { UIColor(named: "Color selection 10")}
    static var ypColorSelection11: UIColor! { UIColor(named: "Color selection 11")}
    static var ypColorSelection12: UIColor! { UIColor(named: "Color selection 12")}
    static var ypColorSelection13: UIColor! { UIColor(named: "Color selection 13")}
    static var ypColorSelection14: UIColor! { UIColor(named: "Color selection 14")}
    static var ypColorSelection15: UIColor! { UIColor(named: "Color selection 15")}
    static var ypColorSelection16: UIColor! { UIColor(named: "Color selection 16")}
    static var ypColorSelection17: UIColor! { UIColor(named: "Color selection 17")}
    static var ypColorSelection18: UIColor! { UIColor(named: "Color selection 18")}
    
    var hexString: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        return String.init(
            format: "%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
}
