import Foundation

class _BookAdvertisement {

			let kModelPropertyBookAdvertisementBody = "body"

			let kModelPropertyBookAdvertisementTitle = "title"

		let kModelPropertyBookAdvertisementBook = "book"

				weak var book: _Book?

			var body: NSString?

			var title: NSString?

			func setBook(book_: _Book?, setInverse: Bool) {

	    				if book_ == nil && setInverse {
	        				self.book?.setAdvertisement(nil, setInverse: false)
	    				}

					    self.book = book_;

		    			if setInverse {
		        			self.book?.setAdvertisement(self, setInverse: false)
		    			}

			}

			func setBook(book_: _Book) {
			    self.setBook(book_, setInverse: true)
			}

}
