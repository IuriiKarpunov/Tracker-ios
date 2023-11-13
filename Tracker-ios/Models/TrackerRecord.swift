//
//  TrackerRecord.swift
//  Tracker-ios
//
//  Created by Iurii on 11.10.23.
//

import Foundation

struct TrackerRecord: Hashable {
    let trackerID: UUID
    let date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(trackerID)
        hasher.combine(date)
    }
    
    static func ==(lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.trackerID == rhs.trackerID && lhs.date == rhs.date
    }
}
