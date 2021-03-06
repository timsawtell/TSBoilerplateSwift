//
//  constants.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation
import UIKit

let kModelFileName = "model.dat"
let kModelArchiveKey = "model"
let kReverseDomainName = "au.com.sawtellsoftware.tsboilerplateswift"
let kUnableToParseMessageText = "Unable to parse results";
let kNoResultsText = "No results found"

var deviceOrientation: UIInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
var isPortrait = deviceOrientation == UIInterfaceOrientation.Portrait || deviceOrientation == UIInterfaceOrientation.PortraitUpsideDown
var isLandscape = deviceOrientation == UIInterfaceOrientation.LandscapeLeft || deviceOrientation == UIInterfaceOrientation.LandscapeRight

let kBaseURL = "www.example.com"

let kPathForModelFile: String = pathForModel()!

func pathForModel() -> String? {
    let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.ApplicationSupportDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    if paths.count > 0 {
        var path = paths[0]
        let fm = NSFileManager()
        if !fm.fileExistsAtPath(path) {
            do {
                try fm.createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                return nil
            }
        }
        path = path.stringByAppendingPathComponent(kModelFileName)
        return path
    }
    
    return nil
}