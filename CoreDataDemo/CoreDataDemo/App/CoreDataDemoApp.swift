//
//  CoreDataDemoApp.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 24.01.2025.
//

import SwiftUI

@main
struct CoreDataDemoApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Tab("Movies", systemImage: "film") {
                    NavigationStack {
                        MovieScreen(viewModel: MovieViewModel(movieInteractor: DefaultMovieInteractor()))
                    }
                }
                Tab("TopMovies", systemImage: "flag.pattern.checkered") {
                    NavigationStack {
                        TopMoviesScreen()
                            .environment(\.managedObjectContext, AppContext.shared.persistentStorageRepository.persistentContainerViewCotnext)
                    }
                }
            }
        }
    }
}
