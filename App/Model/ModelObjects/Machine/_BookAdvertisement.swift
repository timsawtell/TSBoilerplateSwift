import Foundation

// Dont edit this class! Make your changes in the Human version of this class
// This may be formatted like arse but I prefer an easy to read machine.motemplate file over an easy to read class file that is never edited

class _BookAdvertisement: NSObject, NSSecureCoding {

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

	init() {
    }
}
