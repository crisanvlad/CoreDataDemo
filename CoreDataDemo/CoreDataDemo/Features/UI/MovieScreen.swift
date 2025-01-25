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
        .padding()
    }
    
    // MARK: - Subviews
}

#Preview {
    MovieScreen(
        viewModel: MovieViewModel(movieInteractor: DefaultMovieInteractor())
    )
}
