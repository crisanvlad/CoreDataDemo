//
//  AppContext.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import Foundation

final class AppContext {
    // MARK: - Shared instance

    private static let sharedInstance = AppContext()
    static var shared: AppContext { sharedInstance }
    
    // MARK: - Properties

    lazy var persistentStorageRepository: PersistentStorageRepository = DefaultPersistentStorageRepository()
}
