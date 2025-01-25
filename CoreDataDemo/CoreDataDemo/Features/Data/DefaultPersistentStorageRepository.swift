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
    
    // MARK: - Private Properties
    
    private lazy var backgroundContext = persistentContainer.newBackgroundContext()
    
    // MARK: - Init
    
    init() {
        persistentContainer = NSPersistentContainer(name: Constants.persistentContainerName)
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { /* persistentStoreDescription */ _, error in
            if let error {
                fatalError("Core Data Store failed to load with error: \(error)")
            }
        }
    }
    
    // MARK: - PersistentStorageRepository conformance
    
    var persistentContainerViewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self else { return }
            let _ = Movie.mockData(in: persistentContainerViewContext)
            try? saveContext()
        }
    }
    
    func readAllMovies() throws -> [Movie] {
        let movieFetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        return try persistentContainer.viewContext.fetch(movieFetchRequest)
    }
    
    func readMovies(named: String) -> [Movie] {
        let movieFetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        let predicate = NSPredicate(format: "%K CONTAINS[cd] %@", #keyPath(Movie.name), named)
        let sortDescriptor = NSSortDescriptor(keyPath: \Movie.name, ascending: true)
        movieFetchRequest.predicate = predicate
        movieFetchRequest.sortDescriptors = [sortDescriptor]
        return (try? persistentContainer.viewContext.fetch(movieFetchRequest)) ?? []
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
    
    func deleteAllMovies() throws {
        let movies = try readAllMovies()
        try movies.forEach { try deleteMovie($0) }
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
    
    func fetch(_ completion: @escaping () -> Void) {
        persistentContainer.performBackgroundTask { [weak self] _ in
            let request: NSFetchRequest<NSManagedObjectID> = NSFetchRequest(entityName: "Movie")
            // request.sortDescriptors = [NSSortDescriptor(keyPath: \ToDoItem.dueDate, ascending: true)]
            // request.propertiesToFetch = ["dueDate"]
            request.resultType = .managedObjectIDResultType
            
//            self?.fetchedIDs = (try? context.fetch(request)) ?? []
            
            completion()
        }
    }
    
    func fetchToDoItems(dueBefore: Date, in context: NSManagedObjectContext, _ completion: @escaping ([Movie]) -> Void) {
        context.perform {
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            request.predicate = NSPredicate(format: "%K < %@", #keyPath(Movie.releaseDate), dueBefore as NSDate)
            let items = try? context.fetch(request)
            completion(items ?? [])
        }
    }
    
    func fetchToDoItems(dueBefore: Date, in context: NSManagedObjectContext) -> [Movie] {
        var items: [Movie]?
        context.performAndWait {
            let request: NSFetchRequest<Movie> = Movie.fetchRequest()
            request.predicate = NSPredicate(format: "%K < %@", #keyPath(Movie.releaseDate), dueBefore as NSDate)
            items = try? context.fetch(request)
        }
        return items ?? []
    }
}
