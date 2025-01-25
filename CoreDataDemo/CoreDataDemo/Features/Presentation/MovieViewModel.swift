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
    @Published var error: String?
    
    // MARK: - Dependencies
    
    private let movieInteractor: any MovieInteractor
    
    // MARK: - Init
    
    init(
        movieInteractor: any MovieInteractor
    ) {
        self.movieInteractor = movieInteractor
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
        } catch {
            self.error = error.localizedDescription
        }
    }
}
