//
//  GCD.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 25/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}