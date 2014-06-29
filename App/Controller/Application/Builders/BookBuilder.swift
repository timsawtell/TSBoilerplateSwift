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
        let auth = Author()
        book.setAuthor(auth)
        BookBuilder.updateObjWithJSONDict(book, json: json)
        return book
    }
    
    class func updateObjWithJSONDict(obj: Book, json: NSDictionary) ->Book {
        if let author = obj.author {
            author.name = json.objectForKey("artistName") as? NSString
        }
        obj.title = json.objectForKey("trackName") as? NSString
                
        return obj
    }
}