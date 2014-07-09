//
//  TestModel.swift
//  TSBoilerplateSwift
//
//  Created by Tim Sawtell on 6/06/2014.
//  Copyright (c) 2014 Sawtell Software. All rights reserved.
//

import XCTest
import Foundation
import UIKit

class TestModel: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testModelRetainIntegrity() {
        var book = Book()
        weak var ad = BookAdvertisement()
        weak var author = Author()
        
        author?.addBooksObject(book)
        
        XCTAssertNotNil(book, "book was nil")
        
        XCTAssertEqualObjects(author, book.author, "not the same author")
        book.setAuthor(nil)
        XCTAssertNil(author, "author not nil!")
    
        book.setAdvertisement(ad)
        XCTAssertEqualObjects(ad, book.advertisement, "not the same advertisement")
        book.setAdvertisement(nil)
        XCTAssertNil(ad, "ad not nil!")
    }
    
    func testModelSerialise() {
        let a = Author()
        let data = CommandCenter.archiveRootObject(a, key: "author")
        XCTAssertNotNil(data, "data not created")
        let b: AnyObject = CommandCenter.unarchiveData(data!, ofClass: Author.self, key: "author")!
        XCTAssertNotNil(b, "couldn't unarchive the archived author")
        XCTAssertTrue(b.isKindOfClass(Author.self), "b wasn't an author when it was decoded")
    }
}
