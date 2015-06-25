import Foundation

// Dont edit this class! Make your changes in the Human version of this class
// This may be formatted like arse but I prefer an easy to read machine.motemplate file over an easy to read class file that is never edited
// If you want to alter the model, open the Model.xcdatamodeld file and make your changes. Change the project's scheme to "Build Data Model". Build the app. Switch back to the TSBoilerplateSwift scheme to see the results

class _BookAdvertisement: NSObject, NSSecureCoding {

			let kModelPropertyBookAdvertisementBody = "body"

			let kModelPropertyBookAdvertisementTitle = "title"

		let kModelPropertyBookAdvertisementBook = "book"

			  private weak var _book: _Book?
				weak var book: _Book? {
					set(value) {
						_book = value
					}
					get {
						return _book
					}
				}

				var body = NSString() // vanilla Foundation type

				var title = NSString() // vanilla Foundation type

	override init() {
    }

				func setBook(book_: _Book?, setInverse: Bool) {

		    				if book_ == nil && setInverse {
		        				book?.setAdvertisement(nil, setInverse: false)
		    				}

		    	book = book_

			    			if setInverse {
			        			book?.setAdvertisement(self, setInverse: false) 
			    			}

			}

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder) {

	    			aCoder.encodeObject(body, forKey:kModelPropertyBookAdvertisementBody)

	    			aCoder.encodeObject(title, forKey:kModelPropertyBookAdvertisementTitle)

	    			if let realbook = book {
	    				aCoder.encodeObject(realbook, forKey:kModelPropertyBookAdvertisementBook) //2
	    			}

    }

    required init(coder aDecoder: NSCoder) {
    	super.init()

						body = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookAdvertisementBody) as! NSString // vanilla Foundation type

						title = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookAdvertisementTitle) as! NSString // vanilla Foundation type

	        		book = aDecoder.decodeObjectOfClass(_Book.self, forKey:kModelPropertyBookAdvertisementBook) as? _Book // transient or optional

    }
}
