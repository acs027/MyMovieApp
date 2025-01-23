//
//  MyDataManager.swift
//  MyMovieApp
//
//  Created by ali cihan on 10.12.2024.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        self.container = NSPersistentContainer(name: "MyMovieApp")
        //        self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        self.container.viewContext.mergePolicy = CustomMergePolicy()
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Error loading container: \(error), \(error.userInfo)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                debugPrint("Couldn't save to the core data")
            }
        }
    }
    
    func cleanOldData() {
        let context = container.viewContext
        let fetchRequestByTime = fetchRequestByTime()
        let fetchRequestForAll = NSFetchRequest<NSFetchRequestResult>(entityName: "CDMovie")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequestForAll)
        guard let movie = try? context.fetch(fetchRequestByTime) else { return }
        guard let timeDifference = movie.first?.savedDate?.timeIntervalSinceNow else { return }
        debugPrint(timeDifference)
        if abs(timeDifference) > 3600 {
            do {
                try context.execute(batchDeleteRequest)
                try context.save()
            } catch {
                debugPrint("Deleting core data failed")
            }
        }
    }
    
    func fetchRequestByTime() -> NSFetchRequest<CDMovie> {
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "savedDate", ascending: true)]
        fetchRequest.fetchLimit = 1
        return fetchRequest
    }
    
    func fetchRequest(for category: MovieCategory, offset: Int = 0) -> NSFetchRequest<CDMovie> {
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        fetchRequest.predicate = category.predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "savedDate", ascending: true)]
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = 20
        return fetchRequest
    }
    
    func fetchMovies(for category: MovieCategory, offset: Int = 0) -> [CDMovie] {
        let fetchRequest: NSFetchRequest<CDMovie> = CDMovie.fetchRequest()
        fetchRequest.predicate = category.predicate
        fetchRequest.sortDescriptors = category.sortDescriptors
        fetchRequest.fetchOffset = offset
        fetchRequest.fetchLimit = 20
        if let movies = try? container.viewContext.fetch(fetchRequest) {
            return movies
        } else {
            return []
        }
    }
}

extension MovieCategory {
    var sortDescriptors: [NSSortDescriptor] {
        switch self {
        case .nowPlaying:
            [NSSortDescriptor(key: "nowPlayingDate", ascending: true)]
        case .popular:
            [NSSortDescriptor(key: "popularDate", ascending: true)]
        case .upcoming:
            [NSSortDescriptor(key: "upcomingDate", ascending: true)]
        }
    }
}
