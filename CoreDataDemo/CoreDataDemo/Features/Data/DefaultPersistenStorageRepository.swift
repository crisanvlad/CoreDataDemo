//
//  DefaultPersistenStorageRepository.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import CoreData
import Foundation

final class DefaultPersistenStorageRepository: PersistentStorageRepository {
    // MARK: - Nested Properties
    
    private enum Constants {
        static let persistentContainerName = "CoreDataModel"
    }
    
    // MARK: - Dependencies
    
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Init
    
    init() {
        persistentContainer = NSPersistentContainer(name: Constants.persistentContainerName)
        persistentContainer.loadPersistentStores { /* persistentStoreDescription */ _, error in
            if let error {
                fatalError("Core Data Store failed to load with error: \(error)")
            }
        }
    }
}
