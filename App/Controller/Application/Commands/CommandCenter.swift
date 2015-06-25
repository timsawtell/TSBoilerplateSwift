//
//  CommandCenter.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class CommandCenter {

    class func securelyArchiveRootObject(object: NSObject, key: NSString) -> NSData? {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data);
        archiver.requiresSecureCoding = true
        archiver.encodeObject(object, forKey: key as String)
        archiver.finishEncoding()
        return data
    }
    
    class func securelyUnarchiveData(data: NSData, ofClass:AnyClass!, key: NSString) -> AnyObject? {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data);
        unarchiver.requiresSecureCoding = true
        let x = unarchiver.decodeObjectOfClass(ofClass, forKey: key as String) as? NSObject
        return x
    }
    
    class func archiveRootObject(object: NSObject, key: NSString) -> NSData? {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data);
        archiver.encodeObject(object, forKey: key as String)
        archiver.finishEncoding()
        return data
    }
    
    class func unarchiveData(data: NSData, ofClass:AnyClass!, key: NSString) -> AnyObject? {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: data);
        let x = unarchiver.decodeObjectForKey(key as String) as? NSObject
        return x
    }
    
    class func getModelDataFromDisk() -> Model {
        let model = Model()
        do {
            let data = try NSData(contentsOfFile: kPathForModelFile, options: NSDataReadingOptions.DataReadingMappedIfSafe)
            if let modelInstance = CommandCenter.securelyUnarchiveData(data, ofClass:Model.self, key: kModelArchiveKey) as? Model {
                return modelInstance
            } else {
                return model
            }
        } catch {
            return model
        }
    }
}