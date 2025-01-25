//
//  MovieViewModel.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import Combine
import CoreData
import Foundation

final class MovieViewModel: ObservableObject {
    // MARK: - Published Properties
    
    @Published var movieName: String = .init()
    @Published var movies: [Movie] = []
    
    // There is an to use NSManagedObjectID to identify the managed object instance
//    @Published var selectedMovieIDs: Set<NSManagedObjectID> = []
    
    @Published var selectedMovies: Set<Movie> = []
    @Published var error: String?
    @Published var searchedMovieName = String()
    
    // MARK: - Private Properties
    
    private var searchSubscription: AnyCancellable?
    
    // MARK: - Dependencies
    
    private let movieInteractor: any MovieInteractor
    
    // MARK: - Init
    
    init(
        movieInteractor: any MovieInteractor
    ) {
        self.movieInteractor = movieInteractor
        subscribeToSearch()
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
    
    func deleteMovies() {
        do {
            try movieInteractor.deleteMovies(Array(selectedMovies))
            selectedMovies.removeAll()
            fetchAllMovies()
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func cancelMultipleEdit() {
        selectedMovies.removeAll()
    }
    
    // MARK: - Private Methods
    
    private func subscribeToSearch() {
        searchSubscription = $searchedMovieName
            .dropFirst()
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }
                if searchText.isEmpty {
                    fetchAllMovies()
                } else {
                    movies = movieInteractor.getMovies(named: searchText)
                }
            }
    }
    
    private func fetchAllMovies() {
        do {
            movies = try movieInteractor.getAllMovies()
        } catch {
            self.error = error.localizedDescription
        }
    }
}
