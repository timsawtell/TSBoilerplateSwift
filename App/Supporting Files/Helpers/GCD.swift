//
//  GCD.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 25/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

func waitThenRunOnMain(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}

func waitThenRunOnGlobal(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_global_queue(0, 0), closure)
}