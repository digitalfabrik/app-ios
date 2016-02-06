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
        // Back to menu
        let changeButton = app!.navigationBars.buttons["Change"]
        if changeButton.exists {
            changeButton.tap()
        }
        
        snapshot("1-cities", waitForLoadingIndicator: true)
        
        app!.collectionViews.childrenMatchingType(.Cell).matchingIdentifier("Augsburg").elementBoundByIndex(1)
            .otherElements.containingType(.StaticText, identifier:"Augsburg").element.tap()
        
        snapshot("2-locations", waitForLoadingIndicator: true)

        app!.collectionViews.childrenMatchingType(.Cell).matchingIdentifier("English").elementBoundByIndex(1)
            .otherElements.containingType(.StaticText, identifier:"English").element.tap()
        
        wait(2)
        
        snapshot("3-overview", waitForLoadingIndicator: true)
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["Arrival Information"].tap()
        
        snapshot("4-list", waitForLoadingIndicator: true)
        
        app!.tables.cells.elementBoundByIndex(0).tap()
        
        snapshot("5-webview", waitForLoadingIndicator: true)
    }
    
    private func wait(delay: NSTimeInterval) {
        let expectation = expectationWithDescription("Wait")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), expectation.fulfill)
        waitForExpectationsWithTimeout(delay * 2, handler: nil)
    }
    
}
