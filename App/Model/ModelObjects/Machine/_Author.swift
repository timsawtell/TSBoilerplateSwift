import Foundation

class _Author {

			let kModelPropertyAuthorAge = "age"

			let kModelPropertyAuthorName = "name"

		let kModelPropertyAuthorBooks = "books"

			var books: NSMutableSet = NSMutableSet()

			var age: NSNumber?

			var name: NSString?

			func addBooksObject(value_: Book, setInverse: Bool) {
				self.books.addObject(value_)

						if setInverse {
					        value_.setAuthor(self as? Author, setInverse:false);
					    }

			}

			func addBooksObject(value_: Book) {
				self.addBooksObject(value_, setInverse: true)
			}

			func removeAllBooks() {
				self.books = NSMutableSet();
			}

			func removeBooksObject(value_: Book, setInverse: Bool) {

					    if setInverse {
					        value_.setAuthor(nil, setInverse:false);
					    }

			    if value_ != nil {
			        self.books.removeObject(value_)
			    }
			}

			func removeBooksObject(value_: Book) {
				self.removeBooksObject(value_, setInverse:true)
			}

}
