import Foundation

class _Book: NSObject, NSCoding {

			let kModelPropertyBookBlurb = "blurb"

			let kModelPropertyBookPrice = "price"

			let kModelPropertyBookTitle = "title"

		let kModelPropertyBookAdvertisement = "advertisement"

		let kModelPropertyBookAuthor = "author"

					var advertisement: _BookAdvertisement?;

				weak var author: _Author?

			var blurb: NSString?

			var price: NSString?

			var title: NSString?

			func setAdvertisement(advertisement_: _BookAdvertisement?, setInverse: Bool) {

		    				if advertisement_ == nil && setInverse {
		        				self.advertisement?.setBook(nil, setInverse: false)
		    				}

		    	self.advertisement = advertisement_

			    			if setInverse {
			        			self.advertisement?.setBook(self, setInverse: false)//2
			    			}

			}

				func setAdvertisement(advertisement_: _BookAdvertisement?) {
				    self.setAdvertisement(advertisement_, setInverse: true)
				}

			func setAuthor(author_: _Author?, setInverse: Bool) {

		    				if author_ == nil && setInverse {
		        				self.author?.removeBooksObject(self, setInverse: false)
		    				}

		    	self.author = author_

			    			if setInverse {
			        			self.author?.addBooksObject(self, setInverse: false)//0
			    			}

			}

				func setAuthor(author_: _Author?) {
				    self.setAuthor(author_, setInverse: true)
				}

	func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(self.blurb, forKey:kModelPropertyBookBlurb)

	    		aCoder.encodeObject(self.price, forKey:kModelPropertyBookPrice)

	    		aCoder.encodeObject(self.title, forKey:kModelPropertyBookTitle)

	    	aCoder.encodeObject(self.advertisement, forKey:kModelPropertyBookAdvertisement)

	    	aCoder.encodeObject(self.author, forKey:kModelPropertyBookAuthor)

    }

    init(coder aDecoder: NSCoder!) {

	    				self.blurb = aDecoder.decodeObjectForKey(kModelPropertyBookBlurb) as? NSString

	    				self.price = aDecoder.decodeObjectForKey(kModelPropertyBookPrice) as? NSString

	    				self.title = aDecoder.decodeObjectForKey(kModelPropertyBookTitle) as? NSString

	        	self.advertisement = aDecoder.decodeObjectForKey(kModelPropertyBookAdvertisement) as? _BookAdvertisement

	        	self.author = aDecoder.decodeObjectForKey(kModelPropertyBookAuthor) as? _Author

    }

/* to be fixed when Swift supports creating a set of Class types

    class func supportsSecureCoding() -> Bool {
        return true
    }

    func encodeWithCoder(aCoder: NSCoder!) {

	    		aCoder.encodeObject(self.blurb, forKey:kModelPropertyBookBlurb)

	    		aCoder.encodeObject(self.price, forKey:kModelPropertyBookPrice)

	    		aCoder.encodeObject(self.title, forKey:kModelPropertyBookTitle)

	    	aCoder.encodeObject(self.advertisement, forKey:kModelPropertyBookAdvertisement)

	    	aCoder.encodeObject(self.author, forKey:kModelPropertyBookAuthor)

    }

    init(coder aDecoder: NSCoder!) {

	    				self.blurb = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookBlurb) as? NSString

	    				self.price = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookPrice) as? NSString

	    				self.title = aDecoder.decodeObjectOfClass(NSString.self, forKey:kModelPropertyBookTitle) as? NSString

	        	self.advertisement = aDecoder.decodeObjectOfClass(BookAdvertisement.self, forKey:kModelPropertyBookAdvertisement) as? _BookAdvertisement

	        	self.author = aDecoder.decodeObjectOfClass(Author.self, forKey:kModelPropertyBookAuthor) as? _Author

    }
*/
	init() {
    }

}