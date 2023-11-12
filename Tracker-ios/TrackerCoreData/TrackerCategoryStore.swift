//
//  TrackerCategoryStore.swift
//  Tracker-ios
//
//  Created by Iurii on 08.11.23.
//

import CoreData
import UIKit

enum TrackerCategoryStoreError: Error {
    case missingRequiredFields
}

struct TrackerCategoryStoreUpdate {
    struct Move: Hashable {
        let oldIndex: Int
        let newIndex: Int
    }
    let insertedIndexes: IndexSet
    let deletedIndexes: IndexSet
    let updatedIndexes: IndexSet
    let movedIndexes: Set<Move>
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func store(
        _ store: TrackerCategoryStore,
        didUpdate update: TrackerCategoryStoreUpdate
    )
}

final class TrackerCategoryStore: NSObject {
    
    //MARK: - Public Variables
    
    weak var delegate: TrackerCategoryStoreDelegate?
    static let shared = TrackerCategoryStore()
    
    var trackerCategory: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController?.fetchedObjects,
            let trackerCategory = try? objects.map({ try self.trackerCategory(from: $0) })
        else { return [] }
        return trackerCategory
    }
    
    //MARK: - Private Variables
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    private var movedIndexes: Set<TrackerCategoryStoreUpdate.Move>?
    
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
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        self.fetchedResultsController = controller
        
        try controller.performFetch()
    }
    
    //MARK: - Public Methods
    
    func addNewTrackerCategory(_ trackerCategory: TrackerCategory) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.title = trackerCategory.title
        
        for tracker in trackerCategory.trackers {
            let trackerCoreData = TrackerCoreData(context: context)
            
            trackerCoreData.id = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.color = tracker.color.hexString
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = tracker.schedule.compactMap { $0.rawValue }.joined(separator: ",") as NSObject
            
            trackerCategoryCoreData.addToTrackers(trackerCoreData)
        }
        
        try context.save()
    }
    
    func addTracker(_ tracker: Tracker, to trackerCategory: TrackerCategory) throws {
        let category = fetchedResultsController?.fetchedObjects?.first {
            $0.title == trackerCategory.title
        }
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.color = tracker.color.hexString
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = tracker.schedule.compactMap { $0.rawValue }.joined(separator: ",") as NSObject
        
        category?.addToTrackers(trackerCoreData)
        try context.save()
    }
    
    //MARK: - Private Methods
    
    func trackerCategory(from trackerCategoryCorData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCorData.title,
              let trackerCoreDataArray = trackerCategoryCorData.trackers?.allObjects as? [TrackerCoreData] else {
            throw TrackerCategoryStoreError.missingRequiredFields
        }
        
        let trackers = try trackerCoreDataArray.map { try TrackerStore.shared.tracker(from: $0) }
        return TrackerCategory(title: title, trackers: trackers)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
        movedIndexes = Set<TrackerCategoryStoreUpdate.Move>()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(
            self,
            didUpdate: TrackerCategoryStoreUpdate(
                insertedIndexes: insertedIndexes!,
                deletedIndexes: deletedIndexes!,
                updatedIndexes: updatedIndexes!,
                movedIndexes: movedIndexes!
            )
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
        movedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = indexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = indexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        case .move:
            guard let oldIndexPath = indexPath, let newIndexPath = newIndexPath else { fatalError() }
            movedIndexes?.insert(.init(oldIndex: oldIndexPath.item, newIndex: newIndexPath.item))
        @unknown default:
            fatalError()
        }
    }
}
