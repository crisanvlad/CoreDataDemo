//
//  TopMoviesScreen.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import SwiftUI

struct TopMoviesScreen: View {
    @State private var searchText = String()

    @FetchRequest(fetchRequest: Movie.moviesByRating)
    private var movies: FetchedResults<Movie>

    @SectionedFetchRequest(fetchRequest: Movie.moviesByReleaseDate, sectionIdentifier: \Movie.releaseDate)
    private var releaseMovies: SectionedFetchResults<Date, Movie>

    var body: some View {
        topRatedMovies
        moviesBySection
    }

    // MARK: - Subviews

    private var topRatedMovies: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Top Rated Movies")
                .padding()
            ForEach(movies) { movie in
                HStack {
                    Text(movie.name)
                    Spacer()
                    Text("\(movie.rating)")
                }
                .padding(.horizontal)
            }
        }
        .padding()
        .searchable(text: $searchText)
        .onChange(of: searchText) { _, newValue in
            // This normally should be debounced somewhere
            guard !newValue.isEmpty else {
                movies.nsPredicate = nil
                return
            }

            movies.nsPredicate = NSPredicate(format: "%K CONTAINS[cd] %@", argumentArray: [#keyPath(Movie.name), newValue])
        }
    }

    private var moviesBySection: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Movies by release date")
                .padding()
            List {
                ForEach(releaseMovies) { section in
                    Section(header: Text("Released in: \(section.id.formatted())")) {
                        ForEach(section) { movie in
                            HStack {
                                Text(movie.name)
                                Spacer()
                                Text("\(movie.releaseDate.formatted())")
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    TopMoviesScreen()
}
