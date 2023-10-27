//
//  TreckersCollectionViewCellDelegate.swift
//  Tracker-ios
//
//  Created by Iurii on 27.10.23.
//

import Foundation

protocol TreckersCollectionViewCellDelegate: AnyObject {
    func updateCompletedTrackers(trackerID: UUID)
}
