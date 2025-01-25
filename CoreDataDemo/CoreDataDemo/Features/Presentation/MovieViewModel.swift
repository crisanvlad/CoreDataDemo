//
//  MovieViewModel.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import Combine
import Foundation

final class MovieViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var movieName: String = .init()
    @Published var movies: [Movie] = []
    @Published var error: String?
    
    // MARK: - Dependencies
    
    private let movieInteractor: any MovieInteractor
    
    // MARK: - Init
    
    init(
        movieInteractor: any MovieInteractor
    ) {
        self.movieInteractor = movieInteractor
        fetchAllMovies()
    }
    
    // MARK: - Internal Methods
    
    func saveMovie() {
        error = nil
        guard !movieName.isEmpty else {
            error = "Empty name is not allowed"
            return
        }
        do {
            try movieInteractor.saveMovie(name: movieName)
            movies = try movieInteractor.getAllMovies()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func deleteMovie(atIndex offsets: IndexSet) {
        let moviesToRemove = offsets.map { movies[$0] }
        moviesToRemove.forEach { movie in
            do {
                try movieInteractor.deleteMovie(movie)
                fetchAllMovies()
            } catch {
                self.error = error.localizedDescription
            }
        }
        
    }
    
    // MARK: - Private Methods
    
    private func fetchAllMovies() {
        do {
            movies = try movieInteractor.getAllMovies()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
