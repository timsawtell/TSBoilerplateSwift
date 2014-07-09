import Foundation

// Dont edit this class! Make your changes in the Human version of this class
// This may be formatted like arse but I prefer an easy to read machine.motemplate file over an easy to read class file that is never edited

class _Author: NSObject, NSSecureCoding {

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

	        	self.books = aDecoder.decodeObjectOfClasses(NSSet(objects:[NSMutableSet.self, Author.self]), forKey:kModelPropertyAuthorBooks) as NSMutableSet

    }

	init() {
    }
}
