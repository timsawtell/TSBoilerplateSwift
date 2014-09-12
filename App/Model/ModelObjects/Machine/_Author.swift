import Foundation

// Dont edit this class! Make your changes in the Human version of this class
// This may be formatted like arse but I prefer an easy to read machine.motemplate file over an easy to read class file that is never edited

class _Author: NSObject, NSSecureCoding {

			let kModelPropertyAuthorAge = "age"

			let kModelPropertyAuthorName = "name"

			let kModelPropertyAuthorTrans = "trans"

		let kModelPropertyAuthorBooks = "books"

			var books = [_Book]() //to many

				var age: NSNumber? //optional or transient

				var name = NSString() // vanilla Foundation type

				var trans: BookAdvertisement? //optional or transient

	override init() {
    }

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

			    if let index = find(books, value_) {
			       	books.removeAtIndex(index)
			    }

			}

			func removeBooksObject(value_: _Book) {
				removeBooksObject(value_, setInverse:true)
			}

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder) {

					if let tmpage = age {
						aCoder.encodeObject(tmpage, forKey:kModelPropertyAuthorAge)
					}

	    			aCoder.encodeObject(name, forKey:kModelPropertyAuthorName)

					if let tmptrans = trans {
						aCoder.encodeObject(tmptrans, forKey:kModelPropertyAuthorTrans)
					}

	    		aCoder.encodeObject(books, forKey:kModelPropertyAuthorBooks) //1

    }

    required init(coder aDecoder: NSCoder) {
    	super.init()

	    				age = aDecoder.decodeObjectOfClass(NSNumber.self, forKey:kModelPropertyAuthorAge) as? NSNumber // transient or optional

						name = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyAuthorName) as NSString // vanilla Foundation type

	    				trans = aDecoder.decodeObjectOfClass(BookAdvertisement.self, forKey:kModelPropertyAuthorTrans) as? BookAdvertisement // transient or optional

	        	books = aDecoder.decodeObjectOfClasses(NSSet(objects:[NSArray.self, _Book.self]), forKey:kModelPropertyAuthorBooks) as [_Book] // to many

    }
}
