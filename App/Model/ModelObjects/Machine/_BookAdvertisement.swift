import Foundation

class _BookAdvertisement: NSObject, NSCoding {

			let kModelPropertyBookAdvertisementBody = "body"

			let kModelPropertyBookAdvertisementTitle = "title"

		let kModelPropertyBookAdvertisementBook = "book"

				weak var book: _Book?

			var body: NSString?

			var title: NSString?

			func setBook(book_: _Book?, setInverse: Bool) {

		    				if book_ == nil && setInverse {
		        				self.book?.setAdvertisement(nil, setInverse: false)
		    				}

		    	self.book = book_

			    			if setInverse {
			        			self.book?.setAdvertisement(self, setInverse: false)//2
			    			}

			}

				func setBook(book_: _Book?) {
				    self.setBook(book_, setInverse: true)
				}

	func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(self.body, forKey:kModelPropertyBookAdvertisementBody)

	    		aCoder.encodeObject(self.title, forKey:kModelPropertyBookAdvertisementTitle)

	    	aCoder.encodeObject(self.book, forKey:kModelPropertyBookAdvertisementBook)

    }

    init(coder aDecoder: NSCoder!) {

	    				self.body = aDecoder.decodeObjectForKey(kModelPropertyBookAdvertisementBody) as? NSString

	    				self.title = aDecoder.decodeObjectForKey(kModelPropertyBookAdvertisementTitle) as? NSString

	        	self.book = aDecoder.decodeObjectForKey(kModelPropertyBookAdvertisementBook) as? _Book

    }

/* to be fixed when Swift supports creating a set of Class types

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(self.body, forKey:kModelPropertyBookAdvertisementBody)

	    		aCoder.encodeObject(self.title, forKey:kModelPropertyBookAdvertisementTitle)

	    	aCoder.encodeObject(self.book, forKey:kModelPropertyBookAdvertisementBook)

    }

    init(coder aDecoder: NSCoder!) {

	    				self.body = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookAdvertisementBody) as? NSString

	    				self.title = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookAdvertisementTitle) as? NSString

	        	self.book = aDecoder.decodeObjectOfClass(Book.self, forKey:kModelPropertyBookAdvertisementBook) as? _Book

    }
*/
	init() {
    }

}
