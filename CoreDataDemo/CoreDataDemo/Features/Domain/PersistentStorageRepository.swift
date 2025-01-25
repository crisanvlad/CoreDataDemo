//
//  PersistentStorageRepository.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import Foundation

protocol PersistentStorageRepository {
    func createMovie(name: String) throws
    func readAllMovies() throws -> [Movie]
    func deleteMovie(_ movie: Movie) throws
    func deleteMovies(_ movies: [Movie]) throws
}
