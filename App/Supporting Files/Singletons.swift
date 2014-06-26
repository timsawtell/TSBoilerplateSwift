//
//  Singletons.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

let GlobalCommandRunner = CommandRunner()
let GlobalModel = Model.sharedModel()!

let GlobalManager = setupGlobalManager()
let GlobalSession = setupGlobalSession()

func setupGlobalManager() -> AFHTTPRequestOperationManager {
    var GlobalManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: kBaseURL))
    GlobalManager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.PrettyPrinted)
    return GlobalManager
}

func setupGlobalSession() -> AFHTTPSessionManager {
    
    var session = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("au.com.sawtellsoftware.wotif")
    var sharedSession = AFHTTPSessionManager(baseURL:NSURL(string:kBaseURL), sessionConfiguration:session)
    return sharedSession
}