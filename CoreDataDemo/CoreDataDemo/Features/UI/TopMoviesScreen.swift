//
//  TopMoviesScreen.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import SwiftUI

struct TopMoviesScreen: View {
    @FetchRequest(fetchRequest: Movie.moviesByRating)
    private var movies: FetchedResults<Movie>

    var body: some View {
        List(movies) { movie in
            HStack {
                Text(movie.name)
                Spacer()
                Text("\(movie.rating)")
            }
        }
    }
}

#Preview {
    TopMoviesScreen()
}
