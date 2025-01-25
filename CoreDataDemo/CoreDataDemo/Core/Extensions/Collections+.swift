//
//  Collections+.swift
//  CoreDataDemo
//
//  Created by Vlad Crisan on 25.01.2025.
//

extension Collection {
    // Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
