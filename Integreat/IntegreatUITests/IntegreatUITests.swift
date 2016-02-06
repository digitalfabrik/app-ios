import XCTest


class IntegreatUITests: XCTestCase {
    
    var app: XCUIApplication?
        
    override func setUp() {
        super.setUp()
        
        continueAfterFailure = false
        
        app = XCUIApplication()
        setupSnapshot(app!)
        app!.launch()
    }
    
    override func tearDown() {
        app = nil
        
        super.tearDown()
    }
    
    func testTakeScreenshots() {
        
        
        
    }
    
}
