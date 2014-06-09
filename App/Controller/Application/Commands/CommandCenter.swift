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
        var data = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data);
        archiver.setRequiresSecureCoding(true)
        archiver.encodeObject(object, forKey: key)
        archiver.finishEncoding()
        return data
    }
    
    class func securelyUnarchiveData(data: NSData, ofClass:AnyClass!, key: NSString) -> AnyObject? {
        var unarchiver = NSKeyedUnarchiver(forReadingWithData: data);
        unarchiver.setRequiresSecureCoding(true)
        var x = unarchiver.decodeObjectOfClass(ofClass, forKey: key) as? NSObject
        return x
    }
    
    class func archiveRootObject(object: NSObject, key: NSString) -> NSData? {
        var data = NSMutableData()
        var archiver = NSKeyedArchiver(forWritingWithMutableData: data);
        archiver.encodeObject(object, forKey: key)
        archiver.finishEncoding()
        return data
    }
    
    class func unarchiveData(data: NSData, ofClass:AnyClass!, key: NSString) -> AnyObject? {
        var unarchiver = NSKeyedUnarchiver(forReadingWithData: data);
        var x = unarchiver.decodeObjectForKey(key) as? NSObject
        return x
    }

    class func pathForModel() -> NSString? {
        if let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true) as? String[] {
            if paths.count > 0 {
                var path = paths[0]
                var fm = NSFileManager()
                if !fm.fileExistsAtPath(path) {
                    var error :NSError?
                    fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil, error: &error)
                }
                path = path.stringByAppendingPathComponent(kModelFileName)
                return path
            }
        }
        return nil
    }
    
}