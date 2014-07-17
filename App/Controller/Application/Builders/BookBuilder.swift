//
//  BookBuilder.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 27/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import Foundation

class BookBuilder: Builder {
    
    class func objFromJSONDict(json: NSDictionary) ->Book {
        
        let book = Book()
        let auth = Author()
        book.setAuthor(auth)
        BookBuilder.updateObjWithJSONDict(book, json: json)
        return book
    }
    
    class func updateObjWithJSONDict(obj: Book, json: NSDictionary) ->Book {
        if let author = obj.author {
            author.name = safeAssign(attemptValue: json["artistName"], defaultValue:"Unknown") as NSString
        }
        obj.title = safeAssign(attemptValue: json["trackName"], defaultValue: "Unknown") as NSString
        obj.price = safeAssign(attemptValue: json["price"], defaultValue: 0.00) as Double
        obj.blurb = safeAssign(attemptValue: json["description"], defaultValue: "Unknown") as NSString
                
        return obj
    }
}