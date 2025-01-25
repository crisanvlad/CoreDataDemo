//
//  DefaultPersistentStorageRepository.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import CoreData
import Foundation

final class DefaultPersistentStorageRepository: PersistentStorageRepository {
    // MARK: - Nested Properties
    
    private enum Constants {
        static let persistentContainerName = "CoreDataModel"
    }
    
    // MARK: - Dependencies
    
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Init
    
    init() {
        persistentContainer = NSPersistentContainer(name: Constants.persistentContainerName)
        persistentContainer.loadPersistentStores { /* persistentStoreDescription */ _, error in
            if let error {
                fatalError("Core Data Store failed to load with error: \(error)")
            }
        }
    }
    
    // MARK: - PersistentStorageRepository conformance
    
    func createMovie(name: String) throws {
        // Create Movie entity on main thread MOC (i.e view context)
        let movie = Movie(context: persistentContainer.viewContext)
        movie.name = name
        
        do {
            // Save Movie entity in Core Data
            try persistentContainer.viewContext.save()
            print("Movie saved successfully")
        } catch {
            // In case of error, discard current MOC
            persistentContainer.viewContext.rollback()
            throw error
        }
    }
    
    func readAllMovies() throws -> [Movie] {
        let movieFetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        return try persistentContainer.viewContext.fetch(movieFetchRequest)
    }
}
