import Foundation

class Book: _Book, NSCoding {

	// add your custom vars here

	init() {
        super.init()
    }

    init(coder aDecoder: NSCoder!) {
    	super.init(coder: aDecoder)
    	// your custom decoding goes here
    }

    override func encodeWithCoder(aCoder: NSCoder!) {
    	super.encodeWithCoder(aCoder)
    	// your custom encoding goes here

    }

/*
    override class func supportsSecureCoding() -> Bool {
        return true
    }
*/
}