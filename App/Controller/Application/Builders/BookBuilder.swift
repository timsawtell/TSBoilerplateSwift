//
//  BookBuilder.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 27/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class BookBuilder {
    
    class func objFromJSONDict(json: NSDictionary) ->Book {
        
        let book = Book()
        book.author = Author()
        BookBuilder.updateObjWithJSONDict(book, json: json)
        return book
    }
    
    class func updateObjWithJSONDict(obj: Book, json: NSDictionary) ->Book {
        obj.author!.name = json.valueForKey("artistName") as? NSString
        obj.title = json.valueForKey("trackName") as? NSString
        
        return obj
    }
}