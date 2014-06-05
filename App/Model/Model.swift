//
//  Model.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

var _modelInstantied = false // just in case a programmer doesnt use the globalModel object from Singleton.swift and instead calls Model.sharedModel()

class Model :NSObject, NSSecureCoding {
    
    var strings: String[] = [];
    
    init() {
        
    }
    
    func save() {
        let data = CommandCenter.securelyArchiveRootObject(self, key: kModelArchiveKey)
        if !data?.writeToFile(CommandCenter.pathForModel(), atomically: true) {
            NSLog("counl't write model to disk")
        }
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    //NSSecureCoding
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(strings as NSArray, forKey: "strings")
    }
    
    init(coder aDecoder: NSCoder!) {
        strings = aDecoder.decodeObjectOfClass(NSArray.self, forKey: "strings") as String[]
    }
    
    class func sharedModel() -> Model? {
        if _modelInstantied {
            return globalModel // return the already instantiated global from Singleton.swift
        }
        var path = CommandCenter.pathForModel()
        var error: NSError?
        let data = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingMappedIfSafe, error:&error)
        if (nil == data) {
            _modelInstantied = true
            return Model()
        } else {
            if let modelInstance = CommandCenter.securelyUnarchiveData(data, ofClass:Model.self, key: kModelArchiveKey) as? Model {
                _modelInstantied = true
                return modelInstance
            }
        }
        return nil
    }
}