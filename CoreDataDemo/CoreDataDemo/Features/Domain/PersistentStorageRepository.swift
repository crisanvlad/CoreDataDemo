//
//  PersistentStorageRepository.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import Foundation
import CoreData

protocol PersistentStorageRepository {
    // Used only for the purpose of testing FetchRequest in SwiftUI Views
    var persistentContainerViewCotnext: NSManagedObjectContext {get}
    
    func createMovie(name: String) throws
    func readAllMovies() throws -> [Movie]
    func readMovies(named: String) -> [Movie]
    func deleteMovie(_ movie: Movie) throws
    func deleteMovies(_ movies: [Movie]) throws
}
