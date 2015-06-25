import Foundation

class Book: _Book {

	// add your custom vars here

	override init() {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
    	super.init(coder: aDecoder)
    	// your custom decoding goes here
    }

    override func encodeWithCoder(aCoder: NSCoder) {
    	super.encodeWithCoder(aCoder)
    	// your custom encoding goes here

    }

    override class func supportsSecureCoding() -> Bool {
        return true
    }

}