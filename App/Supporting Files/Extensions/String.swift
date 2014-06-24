//
//  String.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 24/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

extension String {
    func isSane() -> Bool {
        if self.bridgeToObjectiveC().length == 0
            || self == NSNull()
            || self.bridgeToObjectiveC().isEqualToString("")
            || self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == ""  {
                return false
        }
        return true
    }
    
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}