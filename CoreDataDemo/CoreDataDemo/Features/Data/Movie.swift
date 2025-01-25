//
//  Movie.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

import CoreData
import Foundation

// MARK: - Movie

@objc(Movie)
public class Movie: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Movie> {
        return NSFetchRequest<Movie>(entityName: "Movie")
    }

    @NSManaged public var releaseDate: Date
    @NSManaged public var name: String
    @NSManaged public var duration: Int64
    @NSManaged public var watched: Bool
    @NSManaged public var rating: Double
}

// MARK: - Convenience Initializer

extension Movie {
    convenience init(
        releaseDate: Date,
        name: String,
        duration: Int64,
        watched: Bool,
        rating: Double,
        context: NSManagedObjectContext
    ) {
        // Get the NSEntityDescription for "Movie"
        let entity = NSEntityDescription.entity(forEntityName: "Movie", in: context)!

        // Call NSManagedObject’s designated initializer
        self.init(entity: entity, insertInto: context)

        // Set properties
        self.releaseDate = releaseDate
        self.name = name
        self.duration = duration
        self.watched = watched
        self.rating = rating
    }
}
