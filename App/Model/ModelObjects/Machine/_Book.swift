import Foundation

class _Book {

			let kModelPropertyBookBlurb = "blurb"

			let kModelPropertyBookPrice = "price"

			let kModelPropertyBookTitle = "title"

		let kModelPropertyBookAdvertisement = "advertisement"

		let kModelPropertyBookAuthor = "author"

				var advertisement: _BookAdvertisement;

				weak var author: _Author?

			var blurb: NSString?

			var price: NSString?

			var title: NSString?

			func setAdvertisement(advertisement_: _BookAdvertisement?, setInverse: Bool) {

	    				if advertisement_ == nil && setInverse {
	        				self.advertisement?.setBook(nil, setInverse: false)
	    				}

		    		if !self.advertisement.isEqaul(advertisement_) {
						        self.advertisement = advertisement_
		    		}

		    			if setInverse {
		        			self.advertisement?.setBook(self, setInverse: false)
		    			}

			}

			func setAdvertisement(advertisement_: _BookAdvertisement) {
			    self.setAdvertisement(advertisement_, setInverse: true)
			}

			func setAuthor(author_: _Author?, setInverse: Bool) {

	    				if author_ == nil && setInverse {
	        				author.removeBooksObject(self, setInverse: false);
	    				}

					    self.author = author_;

		    			if setInverse {
		        			self.author.addBooksObject(self, setInverse: false)
		    			}

			}

			func setAuthor(author_: _Author) {
			    self.setAuthor(author_, setInverse: true)
			}

}
