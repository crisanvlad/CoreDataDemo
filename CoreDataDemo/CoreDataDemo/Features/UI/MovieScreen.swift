//
//  MovieScreen.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 24.01.2025.
//

import SwiftUI

struct MovieScreen: View {
    // MARK: - State Properties
    
    @State private var editMode: EditMode = .inactive
    
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
            Divider()
                .padding(.bottom, 20)
            listMoviesView
            Spacer()
        }
        .padding()
        .navigationTitle("Movies")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if editMode == .active {
                    Button("", systemImage: "trash") {
                        viewModel.deleteMovies()
                        editMode = .inactive
                    }
                    .tint(.red)
                }
                if editMode == .inactive {
                    Button("Edit") {
                        editMode = .active
                    }
                }
            }
            
            if editMode == .active {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        editMode = .inactive
                        viewModel.cancelMultipleEdit()
                    }
                }
            }
        }
        .environment(\.editMode, $editMode)
    }
    
    // MARK: - Subviews
    
    private var addMovieView: some View {
        VStack(spacing: 20) {
            Text("Add Movie")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title2)
                .padding(.bottom, 10)
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
        .searchable(text: $viewModel.searchedMovieName)
    }
    
    @ViewBuilder
    private var listMoviesView: some View {
        VStack(alignment: .leading) {
            Text("Display Movies List")
                .font(.title2)
                .padding(.bottom, 10)
            if viewModel.movies.isEmpty {
                Text("No Movies")
                    .frame(maxWidth: .infinity)
            } else {
                List(selection: $viewModel.selectedMovies) {
                    // we can use \.objectID with NSManagedObjectID for unique id
                    ForEach(viewModel.movies, id: \.self) { movie in
                        Text(movie.name)
                    }
                    .onDelete(perform: editMode == .inactive ? { offsets in
                        viewModel.deleteMovie(atIndex: offsets)
                    } : nil)
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    NavigationStack {
        MovieScreen(
            viewModel: MovieViewModel(movieInteractor: DefaultMovieInteractor())
        )
    }
}
