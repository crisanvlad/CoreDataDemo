//
//  DefaultMovieInteractor.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import Foundation

struct DefaultMovieInteractor: MovieInteractor {
    // MARK: - Dependencies
    
    private let persistentStorageRepository: PersistentStorageRepository
    
    // MARK: - Init
    
    init(
        persistentStorageRepository: PersistentStorageRepository = AppContext.shared.persistentStorageRepository
    ) {
        self.persistentStorageRepository = persistentStorageRepository
    }
    
    // MARK: - MovieInteractor conformance
    
    func saveMovie(name: String) throws {
        try persistentStorageRepository.createMovie(name: name)
    }
    
    func getAllMovies() throws -> [Movie] {
        try persistentStorageRepository.readAllMovies()
    }
}
