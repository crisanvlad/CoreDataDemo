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
            NavigationStack {
                MovieScreen(viewModel: MovieViewModel(movieInteractor: DefaultMovieInteractor()))
            }
        }
    }
}
