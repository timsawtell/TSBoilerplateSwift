//
//  Model.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class Model :NSObject, NSSecureCoding {
    
    var strings: String[] = String[]();
    
    func save() {
        let data = CommandCenter.securelyArchiveRootObject(self, key: kModelArchiveKey)
        
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(strings, forKey: "strings")
    }
    
    init(coder aDecoder: NSCoder!) {
        strings = aDecoder.decodeObjectOfClass(NSArray.self, forKey: "strings") as String[]
    }
}