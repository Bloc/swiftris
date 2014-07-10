//
//  Utils.swift
//  Swiftris
//
//  Created by Stanley Idesis on 7/10/14.
//  Copyright (c) 2014 Bloc. All rights reserved.
//

import Foundation

// Synchronize any closure
func synchronized(lock: AnyObject, closure: () -> ()) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}