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

// MARK: - Static Fetch Requests

extension Movie {
    static var moviesByRating: NSFetchRequest<Movie> = {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.rating, ascending: false)]
        return request
    }()

    static var moviesByReleaseDate: NSFetchRequest<Movie> = {
        let request: NSFetchRequest<Movie> = Movie.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Movie.releaseDate, ascending: false)]

        return request
    }()
}

extension Movie {
    static func mockData(in context: NSManagedObjectContext) -> [Movie] {
        var result: [Movie] = []
        for idx in 0 ..< Int.random(in: 5 ... 10) {
            result.append(
                Movie(
                    releaseDate: Date(),
                    name: "Movie_\(idx)",
                    duration: Int64.random(in: 0 ..< 10),
                    watched: Bool.random(),
                    rating: Double.random(in: 0 ... 5),
                    context: context
                )
            )
        }
        return result
    }
}
