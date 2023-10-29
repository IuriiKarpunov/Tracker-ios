//
//  DateExtensions.swift
//  Tracker-ios
//
//  Created by Iurii on 29.10.23.
//

import Foundation

extension Date {
    func dayOfWeek() -> Int {
        let calendar = Calendar(identifier: .gregorian) // Используйте грегорианский календарь
        let components = calendar.dateComponents([.weekday], from: self)
        return (components.weekday ?? 1) - 1 // Преобразуйте в значение от 0 до 6
    }
}
