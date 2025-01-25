//
//  MovieScreen.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 24.01.2025.
//

import SwiftUI

struct MovieScreen: View {
    // MARK: - Dependencies
    
    @StateObject private var viewModel: MovieViewModel
    
    // MARK: - Init
    
    init(viewModel: @autoclosure @escaping () -> MovieViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel())
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading) {
            addMovieView
                .padding(.bottom, 30)
            listMoviesView
        }
        .padding()
    }
    
    // MARK: - Subviews
    
    private var addMovieView: some View {
        VStack(spacing: 20) {
            TextField("Type movie name", text: $viewModel.movieName)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.quinary)
                }
            
            Button("Save Movie") {
                viewModel.saveMovie()
            }
            
            if let error = viewModel.error {
                Text("Error: \(error)")
            }
        }
    }
    
    @ViewBuilder
    private var listMoviesView: some View {
        VStack(alignment: .leading) {
            Text("Movies List")
                .font(.title2)
                .padding(.bottom, 10)
            if viewModel.movies.isEmpty {
                Text("No Movies")
                    .frame(maxWidth: .infinity)
            } else {
                List {
                    ForEach(viewModel.movies, id: \.self) { movie in
                        if let movieName = movie.name {
                            Text(movieName)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    MovieScreen(
        viewModel: MovieViewModel(movieInteractor: DefaultMovieInteractor())
    )
}
