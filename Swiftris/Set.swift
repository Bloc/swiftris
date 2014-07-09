//
//  Set.swift
//  CookieCrunch
//
//  Created by Stanley Idesis on 7/3/14.
//  Copyright (c) 2014 Stanley Idesis. All rights reserved.
//

import Foundation

class Set<T: Hashable>: Sequence, Printable {
    var dictionary = Dictionary<T, Bool>()
    
    func addElement(newElement: T) {
        dictionary[newElement] = true
    }
    
    func removeElement(remove: T) {
        dictionary[remove] = nil
    }
    
    func containsElement(element: T) -> Bool {
        return dictionary[element] != nil
    }
    
    func allElements() -> [T] {
        return Array(dictionary.keys)
    }
    
    var count: Int {
        return dictionary.count
    }
    
    func unionSet(otherSet: Set<T>) -> Set<T> {
        var combined = Set<T>()
        
        for T in dictionary.keys {
            combined.addElement(T)
        }
        
        for T in otherSet.dictionary.keys {
            combined.addElement(T)
        }
        return combined
    }
    
    
    // let's you use for…in loops with this class
    func generate() -> IndexingGenerator<Array<T>> {
        return allElements().generate()
    }
    
    var description: String {
        return dictionary.description
    }
}