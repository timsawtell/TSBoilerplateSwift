//
//  iTunesSearchCommand.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 5/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

/**
* Query the iTunes web service for details on a book, build a Book object with the results and add it to the Model
*/

class iTunesSearchCommand: AsynchronousCommand {
    
    override func execute()  {
        weak var weakSelf = self
        
        let successBlock: NetworkSuccessBlock = { (resultObject, request, response) -> Void in
            if let strongSelf = weakSelf {
                if strongSelf.cancelled { return }
                
                if let responseDict = resultObject as? NSDictionary {
                    if let resultCount: Int = responseDict["resultCount"] as? Int {
                        if resultCount <= 0 {
                            strongSelf.error = NSError.errorWithCode(NSURLErrorCannotParseResponse, text: kNoResultsText)
                            strongSelf.finish()
                            return
                        } else {
                            // we have the info we need, we can start processing the results
                            if let resultsArray: NSArray = responseDict["results"] as? NSArray {
                                if let bookDictionary: NSDictionary = resultsArray.objectAtIndex(0) as? NSDictionary {
                                    // create the book
                                    let book = BookBuilder.objFromJSONDict(bookDictionary)
                                    GlobalModel.books.append(book)
                                    GlobalModel.currentBook = book
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
        
        let errorBlock: NetworkErrorBlock = { (resultObject, error, request, response) -> Void in
            if let strongSelf = weakSelf {
                strongSelf.error = error
                strongSelf.finish()
            }
        }
        
        let params = ["isbn": "055389692X"]
        let headers = ["Accept": "application/json"]
        Network.setBaseURLString("http://itunes.apple.com")
        Network.performDataTask(relativePath: "lookup", method: .GET, parameters: params, additionalHeaders: headers, successBlock: successBlock, errorBlock: errorBlock)
    }
}