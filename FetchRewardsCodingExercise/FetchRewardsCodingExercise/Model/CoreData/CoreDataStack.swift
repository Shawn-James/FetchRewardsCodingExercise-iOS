// Copyright © 2021 Shawn James. All rights reserved.
// Created by Shawn James
// CoreDataStack.swift

import CoreData

class CoreDataStack {
    // shared single instance
    static let shared = CoreDataStack()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoreDataModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Failed to load persistent stores: \(error), \(error.userInfo)")
            }
            persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
        return persistentContainer
    }()

    var mainContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    var backgroundContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    /// Determines whether the event was "favorited" by the user
    func isFavorite(id: Int) -> Bool {
        let request = NSFetchRequest<Favorite>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "id = %d", id)
        request.fetchLimit = 1

        do {
            return try backgroundContext.fetch(request).first != nil
        } catch let error as NSError {
            fatalError("Error checking favorite: \(error), \(error.userInfo)")
        }
    }

    func saveFavorite(id: Int, expiration: String) {
        backgroundContext.performAndWait {
            Favorite(id: id, expiration: expiration, context: mainContext)

            do {
                try mainContext.save()
            } catch let error as NSError {
                fatalError("Error saving new favorite: \(error), \(error.userInfo)")
            }
        }

    }

    func deleteFavorite(id: Int64) {
        let request = NSFetchRequest<Favorite>(entityName: "Favorite")
        request.predicate = NSPredicate(format: "id = %d", id)
        request.fetchLimit = 1

        do {
            if let favorite = try mainContext.fetch(request).first {
                mainContext.delete(favorite)
                try mainContext.save()
            }
        } catch let error as NSError {
            fatalError("Failed to delete favorite: \(error), \(error.userInfo)")
        }
    }

    // Removes events which will no longer appear in search results - prevents endless memory usage
    func removeExpired() {
        let request = NSFetchRequest<Favorite>(entityName: "Favorite")

        do {
            let allFavorites = try backgroundContext.fetch(request)
            for favorite in allFavorites {
                if let expiration = favorite.expiration {
                    if DateFormatter().date(from: expiration) == Date() {
                        deleteFavorite(id: favorite.id)
                    }
                }
            }
        } catch {
            fatalError("\(error)")
        }
    }
}

// Programmer's initializer for new managed object
extension Favorite {
    @discardableResult convenience init(id: Int, expiration: String, context: NSManagedObjectContext) {
        self.init(context: context)

        self.id = Int64(id)
        self.expiration = expiration
    }
}
