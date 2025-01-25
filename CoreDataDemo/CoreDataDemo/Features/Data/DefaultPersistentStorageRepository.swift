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
        try saveContext()
    }
    
    func readAllMovies() throws -> [Movie] {
        let movieFetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        return try persistentContainer.viewContext.fetch(movieFetchRequest)
    }
    
    func deleteMovie(_ movie: Movie) throws {
        // This works because the MOC has a reference to the movie instance (unique objectID)
        persistentContainer.viewContext.delete(movie)
        try saveContext()
    }
    
    func deleteMovie(named: String) throws {
        // Implement a way to delete a movie based on its ID
    }
    
    // MARK: - Private methods
    
    private func saveContext() throws {
        do {
            // Save MOC changes to persistent storage
            try persistentContainer.viewContext.save()
        } catch {
            // In case of error, discard current MOC changes
            persistentContainer.viewContext.rollback()
            throw error
        }
    }
}
