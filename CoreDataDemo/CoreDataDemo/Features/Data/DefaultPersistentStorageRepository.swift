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
        let _ = Movie(
            releaseDate: Date(),
            name: name,
            duration: Int64.random(in: 1..<4),
            watched: Bool.random(),
            rating: Double.random(in: 0..<5),
            context: persistentContainer.viewContext
        )
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
    
    func deleteMovies(_ movies: [Movie]) throws {
        movies.forEach { persistentContainer.viewContext.delete($0) }
        try saveContext()
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
