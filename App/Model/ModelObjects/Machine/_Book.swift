import Foundation

// Dont edit this class! Make your changes in the Human version of this class
// This may be formatted like arse but I prefer an easy to read machine.motemplate file over an easy to read class file that is never edited
// If you want to alter the model, open the Model.xcdatamodeld file and make your changes. Change the project's scheme to "Build Data Model". Build the app. Switch back to the TSBoilerplateSwift scheme to see the results

class _Book: NSObject, NSSecureCoding {

			let kModelPropertyBookBlurb = "blurb"

			let kModelPropertyBookPrice = "price"

			let kModelPropertyBookTitle = "title"

		let kModelPropertyBookAdvertisement = "advertisement"

		let kModelPropertyBookAuthor = "author"

					var advertisement: _BookAdvertisement? //optional

					var author = _Author() // !transient && !optional relationship

				var blurb = NSString() // vanilla Foundation type

				var price = NSNumber() // vanilla Foundation type

				var title = NSString() // vanilla Foundation type

	override init() {
    }

				func setAdvertisement(advertisement_: _BookAdvertisement?, setInverse: Bool) {

		    				if advertisement_ == nil && setInverse {
		        				advertisement?.setBook(nil, setInverse: false)
		    				}

		    	advertisement = advertisement_

			    			if setInverse {
			        			advertisement?.setBook(self, setInverse: false) 
			    			}

			}

				func setAdvertisement(advertisement_: _BookAdvertisement?) {
				    setAdvertisement(advertisement_, setInverse: true)
				}

				func setAuthor(author_: _Author, setInverse: Bool) {

		    	author = author_

		    				if setInverse {
			        			author.addBooksObject(self, setInverse: false) 
			    			}

			}

				func setAuthor(author_: _Author) {
				    setAuthor(author_, setInverse: true)
				}

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder) {

	    			aCoder.encodeObject(blurb, forKey:kModelPropertyBookBlurb)

	    			aCoder.encodeObject(price, forKey:kModelPropertyBookPrice)

	    			aCoder.encodeObject(title, forKey:kModelPropertyBookTitle)

	    			if let realadvertisement = advertisement {
	    				aCoder.encodeObject(realadvertisement, forKey:kModelPropertyBookAdvertisement) //2
	    			}

	    			aCoder.encodeObject(author, forKey:kModelPropertyBookAuthor) //3

    }

    required init(coder aDecoder: NSCoder) {
    	super.init()

						blurb = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookBlurb) as NSString // vanilla Foundation type

						price = aDecoder.decodeObjectOfClass(NSNumber.self, forKey:kModelPropertyBookPrice) as NSNumber // vanilla Foundation type

						title = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookTitle) as NSString // vanilla Foundation type

	        		advertisement = aDecoder.decodeObjectOfClass(_BookAdvertisement.self, forKey:kModelPropertyBookAdvertisement) as? _BookAdvertisement // transient or optional

	        		author = aDecoder.decodeObjectOfClass(_Author.self, forKey:kModelPropertyBookAuthor) as _Author // !transient && !optional relationship

    }
}
