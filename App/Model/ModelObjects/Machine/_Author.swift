import Foundation

// Dont edit this class! Make your changes in the Human version of this class
// This may be formatted like arse but I prefer an easy to read machine.motemplate file over an easy to read class file that is never edited

class _Author: NSObject, NSSecureCoding {

			let kModelPropertyAuthorAge = "age"

			let kModelPropertyAuthorName = "name"

		let kModelPropertyAuthorBooks = "books"

			var books = [_Book]()

			var age: NSNumber?

			var name: NSString?

			func addBooksObject(value_: _Book, setInverse: Bool) {
				books.append(value_)

						if setInverse {
					        value_.setAuthor(self, setInverse:false)
					    }

			}

			func addBooksObject(value_: _Book) {
				addBooksObject(value_, setInverse: true)
			}

			func removeAllBooks() {
				books = [_Book]()
			}

			func removeBooksObject(value_: _Book, setInverse: Bool) {

					    if setInverse {
					        value_.setAuthor(nil, setInverse:false)
					    }

			    if value_ != nil {
			        if let index = find(books, value_) {
			        	books.removeAtIndex(index)
			        }
			    }
			}

			func removeBooksObject(value_: _Book) {
				removeBooksObject(value_, setInverse:true)
			}

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(age, forKey:kModelPropertyAuthorAge)

	    		aCoder.encodeObject(name, forKey:kModelPropertyAuthorName)

	    	aCoder.encodeObject(books, forKey:kModelPropertyAuthorBooks)

    }

    init(coder aDecoder: NSCoder!) {

	    				age = aDecoder.decodeObjectOfClass(NSNumber.self, forKey:kModelPropertyAuthorAge) as? NSNumber

	    				name = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyAuthorName) as? NSString

	        	books = aDecoder.decodeObjectOfClasses(NSSet(objects:[NSArray.self, _Book.self]), forKey:kModelPropertyAuthorBooks) as [_Book]

    }

	init() {
    }
}
