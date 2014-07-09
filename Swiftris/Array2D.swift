//
//  Array2D.swift
//  CookieCrunch
//
//  Created by Stanley Idesis on 7/3/14.
//  Copyright (c) 2014 Stanley Idesis. All rights reserved.
//

import Foundation

class Array2D<T> {
    let columns: Int
    let rows: Int
    let array: Array<T?>
    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(count:rows * columns, repeatedValue: nil)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set {
            array[(row * columns) + column] = newValue
        }
    }
}