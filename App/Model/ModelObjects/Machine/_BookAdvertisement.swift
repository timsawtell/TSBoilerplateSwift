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
		        				book?.setAdvertisement(nil, setInverse: false)
		    				}

		    	book = book_

			    			if setInverse {
			        			book?.setAdvertisement(self, setInverse: false)
			    			}

			}

				func setBook(book_: _Book?) {
				    setBook(book_, setInverse: true)
				}

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(body, forKey:kModelPropertyBookAdvertisementBody)

	    		aCoder.encodeObject(title, forKey:kModelPropertyBookAdvertisementTitle)

	    	aCoder.encodeObject(book, forKey:kModelPropertyBookAdvertisementBook)

    }

    init(coder aDecoder: NSCoder!) {

	    				body = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookAdvertisementBody) as? NSString

	    				title = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookAdvertisementTitle) as? NSString

	        	book = aDecoder.decodeObjectOfClass(_Book.self, forKey:kModelPropertyBookAdvertisementBook) as? _Book

    }

	init() {
    }
}
