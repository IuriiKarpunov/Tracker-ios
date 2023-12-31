//
//  TrackersCollectionViewCellDelegate.swift
//  Tracker-ios
//
//  Created by Iurii on 27.10.23.
//

import Foundation

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}
