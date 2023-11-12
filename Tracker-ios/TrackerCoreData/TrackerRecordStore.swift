//
//  TrackerRecordStore.swift
//  Tracker-ios
//
//  Created by Iurii on 08.11.23.
//

import CoreData
import UIKit

enum TrackerRecordStoreError: Error {
    case missingRequiredFields
}

final class TrackerRecordStore: NSObject {
    
    //MARK: - Public Variables
    
    static let shared = TrackerRecordStore()
    
    //MARK: - Private Variables
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    //MARK: - Initialization
    
    convenience override init() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to get Core Data context")
        }
        try! self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()
        
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.trackerID, ascending: true)
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
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        trackerRecordCoreData.trackerID = trackerRecord.trackerID
        trackerRecordCoreData.date = trackerRecord.date
        
        try context.save()
    }
    
    func deleteTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        
        fetchRequest.predicate = NSPredicate(
            format: " %K == %@",
            #keyPath(TrackerRecordCoreData.trackerID),
            trackerRecord.trackerID as CVarArg
        )
        
        do {
            let trackerRecords = try context.fetch(fetchRequest)
            
            if let deletingRecord = trackerRecords.first {
                context.delete(deletingRecord)
                try context.save()
            } else {
                throw NSError(domain: "YourDomain", code: 404, userInfo: [
                    NSLocalizedDescriptionKey: "No matching record found for deletion. trackerID: \(trackerRecord.trackerID)"
                ])
            }
        } catch {
            throw error
        }
    }
    
    func fetchTrackersRecord() throws -> [TrackerRecord] {
        let fetchRequest = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let trackerRecordFromCoreData = try context.fetch(fetchRequest)
        
        return try trackerRecordFromCoreData.map { try self.trackerRecord(from: $0) }
    }
    
    //MARK: - Private Methods
    
    func trackerRecord(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let trackerID = trackerRecordCoreData.trackerID,
              let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.missingRequiredFields
        }
        
        return TrackerRecord(trackerID: trackerID, date: date)
    }
}
