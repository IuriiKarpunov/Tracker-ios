//
//  TrackerStore.swift
//  Tracker-ios
//
//  Created by Iurii on 08.11.23.
//

import CoreData
import UIKit

enum TrackerStoreError: Error {
    case missingRequiredFields
}

final class TrackerStore {
    
    //MARK: - Public Variables
    
    static let shared = TrackerStore()
    
    //MARK: - Private Variables
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>!
    
    //MARK: - Initialization
    
    convenience init() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        self.fetchedResultsController = controller
        try controller.performFetch()
    }
    
    //MARK: - Public Methods
    
    func addNewTracker(_ tracker: Tracker) throws {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.color = tracker.color.hexString
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.name = tracker.name
        trackerCoreData.schedule = tracker.schedule.compactMap { $0.rawValue }.joined(separator: ",") as NSObject
        
        try context.save()
    }
    
    func tracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.id,
              let color = trackerCoreData.color,
              let emoji = trackerCoreData.emoji,
              let name = trackerCoreData.name,
              let scheduleString = trackerCoreData.schedule as? String else {
            throw TrackerStoreError.missingRequiredFields
        }
        
        let scheduleComponents = scheduleString.components(separatedBy: ",")
        let schedule = scheduleComponents.compactMap { WeekDay(rawValue: $0) }
        
        return Tracker(
            id: id,
            name: name,
            color: color.color,
            emoji: emoji,
            schedule: schedule
        )
    }
}
