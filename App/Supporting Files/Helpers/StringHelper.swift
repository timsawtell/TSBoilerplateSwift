//
//  StringHelper.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 12/09/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import UIKit

extension String {
    
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(.whitespaceAndNewlineCharacterSet())
    }
    
    func substring(location:Int, length:Int) -> String! {
        return (self as NSString).substringWithRange(NSMakeRange(location, length))
    }
    
    subscript(index: Int) -> String! {
        get {
            return self.substring(index, length: 1)
        }
    }
    
    func location(other: String) -> Int {
        return (self as NSString).rangeOfString(other).location
    }
    
    func contains(other: String) -> Bool {
        return (self as NSString).containsString(other)
    }
    
    // http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
    func isNumeric() -> Bool {
        return (self as NSString).rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).location == NSNotFound
    }
}