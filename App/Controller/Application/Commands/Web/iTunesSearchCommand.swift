//
//  iTunesSearchCommand.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class iTunesSearchCommand: AsynchronousCommand {
    override func execute()  {
        
        weak var weakSelf = self
        var successBlock = {(operation: AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            if let strongSelf = weakSelf {
                if strongSelf.cancelled { return }
                
                if let responseDict = responseObject as? NSDictionary {
                    if let resultCount: Int = responseDict.valueForKey("resultCount") as? Int {
                        if resultCount <= 0 {
                            strongSelf.error = NSError.errorWithCode(NSURLErrorCannotParseResponse, text: "No results found")
                            strongSelf.finish()
                            return
                        } else {
                            // we have the info we need, we can start processing the results
                            if let resultsArray: NSArray = responseDict.valueForKey("results") as? NSArray {
                                if let bookDictionary: NSDictionary = resultsArray.objectAtIndex(0) as? NSDictionary {
                                    // create the book
                                    NSLog("\(bookDictionary)")
                                    strongSelf.finish()
                                    return
                                }
                            }
                        }
                    }
                }
                // catch all for the response not being formatted as expected
                strongSelf.error = NSError.errorWithCode(NSURLErrorCannotParseResponse, text: kUnableToParseMessageText)
                strongSelf.finish()
                return
            } else {
                return // the creator of this block (the command) doesn't exist anymore. just finish.
            }
        }
        
        let errorBlock = {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            if let strongSelf = weakSelf {
                strongSelf.error = error
                strongSelf.finish()
            }
        }
        var params = NSDictionary(object: "055389692X", forKey: "isbn")
        GlobalManager.GET("http://itunes.apple.com/lookup", parameters: params, success: successBlock, failure: errorBlock)
    }
}