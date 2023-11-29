//
//  CategoryViewModel.swift
//  Tracker-ios
//
//  Created by Iurii on 17.11.23.
//

import Foundation

class CategoryViewModel {
    
    // MARK: - Stored properties
    
    weak var delegate: CategoryViewControllerDelegate?
    private var trackerCategoryStore = TrackerCategoryStore.shared
    var categories: [TrackerCategory] = []

    // MARK: - Public Methods
    
    func fetchCategories() {
        categories = trackerCategoryStore.trackerCategory
    }

    func numberOfCategories() -> Int {
        return categories.count
    }

    func category(at index: Int) -> String {
        return categories[index].title
    }

    func addCategory(_ category: TrackerCategory) {
        do {
            try trackerCategoryStore.addNewTrackerCategory(category)
            fetchCategories()
        } catch {
            print("Error adding category to CoreData: \(error.localizedDescription)")
        }
    }
    
    func categoryExists(with title: String) -> Bool {
        return categories.contains(where: { $0.title == title })
    }
}
