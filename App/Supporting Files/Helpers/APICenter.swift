//
//  APICenter.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 27/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

typealias AFSuccessBlock = (operation: AFHTTPRequestOperation, responseObject: AnyObject) -> Void
typealias AFErrorBlock = (operation: AFHTTPRequestOperation, error: NSError) -> Void

func setupGlobalManager() -> AFHTTPRequestOperationManager {
    var GlobalManager = AFHTTPRequestOperationManager(baseURL: NSURL(string: kBaseURL))
    GlobalManager.requestSerializer = AFJSONRequestSerializer(writingOptions: NSJSONWritingOptions.PrettyPrinted)
    return GlobalManager
}

func setupGlobalSession() -> AFHTTPSessionManager {
    
    var session = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(kReverseDomainName)
    var sharedSession = AFHTTPSessionManager(baseURL:NSURL(string:kBaseURL), sessionConfiguration:session)
    return sharedSession
}