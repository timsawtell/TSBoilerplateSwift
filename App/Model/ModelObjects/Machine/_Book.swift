import Foundation

class _Book {

			let kModelPropertyBookBlurb = "blurb"

			let kModelPropertyBookPrice = "price"

			let kModelPropertyBookTitle = "title"

		let kModelPropertyBookAdvertisement = "advertisement"

		let kModelPropertyBookAuthor = "author"

					var advertisement: BookAdvertisement?;

				weak var author: Author?

			var blurb: NSString?

			var price: NSString?

			var title: NSString?

			func setAdvertisement(advertisement_: BookAdvertisement?, setInverse: Bool) {

		    				if advertisement_ == nil && setInverse {
		        				self.advertisement?.setBook(nil, setInverse: false)
		    				}

		    		if !self.advertisement == advertisement_ {
						        self.advertisement = advertisement_
		    		}

			    			if setInverse {
			        			self.advertisement?.setBook(self as? Book , setInverse: false)
			    			}

			}

			func setAdvertisement(advertisement_: BookAdvertisement) {
			    self.setAdvertisement(advertisement_, setInverse: true)
			}

			func setAuthor(author_: Author?, setInverse: Bool) {

	    				if author_ == nil && setInverse {
	        				author.removeBooksObject(self as? Book, setInverse: false);
	    				}

					    self.author = author_

		    			if setInverse {
		        			self.author.addBooksObject(self as? Book, setInverse: false)
		    			}

			}

			func setAuthor(author_: Author) {
			    self.setAuthor(author_, setInverse: true)
			}

}
