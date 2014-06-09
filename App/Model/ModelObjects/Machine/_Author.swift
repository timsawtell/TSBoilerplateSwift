import Foundation

class _Author: NSObject, NSCoding {

			let kModelPropertyAuthorAge = "age"

			let kModelPropertyAuthorName = "name"

		let kModelPropertyAuthorBooks = "books"

			var books: NSMutableSet = NSMutableSet()

			var age: NSNumber?

			var name: NSString?

			func addBooksObject(value_: _Book, setInverse: Bool) {
				self.books.addObject(value_)

						if setInverse {
					        value_.setAuthor(self, setInverse:false);
					    }

			}

			func addBooksObject(value_: _Book) {
				self.addBooksObject(value_, setInverse: true)
			}

			func removeAllBooks() {
				self.books = NSMutableSet();
			}

			func removeBooksObject(value_: _Book, setInverse: Bool) {

					    if setInverse {
					        value_.setAuthor(nil, setInverse:false);
					    }

			    if value_ != nil {
			        self.books.removeObject(value_)
			    }
			}

			func removeBooksObject(value_: _Book) {
				self.removeBooksObject(value_, setInverse:true)
			}

	func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(self.age, forKey:kModelPropertyAuthorAge)

	    		aCoder.encodeObject(self.name, forKey:kModelPropertyAuthorName)

	    	aCoder.encodeObject(self.books, forKey:kModelPropertyAuthorBooks)

    }

    init(coder aDecoder: NSCoder!) {

	    				self.age = aDecoder.decodeObjectForKey(kModelPropertyAuthorAge) as? NSNumber

	    				self.name = aDecoder.decodeObjectForKey(kModelPropertyAuthorName) as? NSString

	        	self.books = aDecoder.decodeObjectForKey(kModelPropertyAuthorBooks) as NSMutableSet

    }

/* to be fixed when Swift supports creating a set of Class types

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(self.age, forKey:kModelPropertyAuthorAge)

	    		aCoder.encodeObject(self.name, forKey:kModelPropertyAuthorName)

	    	aCoder.encodeObject(self.books, forKey:kModelPropertyAuthorBooks)

    }

    init(coder aDecoder: NSCoder!) {

	    				self.age = aDecoder.decodeObjectOfClass(NSNumber.self, forKey:kModelPropertyAuthorAge) as? NSNumber

	    				self.name = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyAuthorName) as? NSString

	        	self.books = aDecoder.decodeObjectOfClass(NSMutableSet.self, forKey:kModelPropertyAuthorBooks) as NSMutableSet

    }
*/
	init() {
    }

}
