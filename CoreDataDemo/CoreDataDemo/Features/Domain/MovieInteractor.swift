//
//  MovieInteractor.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import Foundation

protocol MovieInteractor {
    func saveMovie(name: String) throws
    func getAllMovies() throws -> [Movie]
    func getMovies(named: String) -> [Movie]
    func deleteMovie(_ movie: Movie) throws
    func deleteMovies(_ movies: [Movie]) throws
    func deleteAllMovies() throws
}
