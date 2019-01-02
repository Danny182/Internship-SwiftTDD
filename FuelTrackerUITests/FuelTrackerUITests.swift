//
//  FuelTrackerUITests.swift
//  FuelTrackerUITests
//
//  Created by Daniel Zanchi on 16/10/2018.
//  Copyright © 2018 Daniel Zanchi. All rights reserved.
//

import XCTest
@testable import FuelTracker

class FuelTrackerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launchArguments = ["-resetTable"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testTitle() {
        let fuelRegisterNavigationBar = app.navigationBars["Fuel Register"]
        let fuelRegisterTitle = fuelRegisterNavigationBar.otherElements["Fuel Register"]
        XCTAssert(fuelRegisterTitle.exists)
    }
    
    func testAddButton() {
        XCTAssert(app.navigationBars["Fuel Register"].exists)
        app.navigationBars["Fuel Register"].buttons["Add"].tap()
        XCTAssert(app.navigationBars["Add Fuel"].exists)
    }
    
    func testTableView() {
        XCTAssertEqual(app.tables.count, 1)
    }
    
    func testTableViewRowCount() {
        let rows = app.tables.cells.count
        addFuel()
        XCTAssertEqual(app.tables.cells.count , rows + 1)
    }
    
    func testEditFuel() {
        addFuel()
        
        XCTAssertFalse(app.staticTexts["30.00 €"].exists)
        
        app.tables.cells.firstMatch.tap()
            
        let amountTextField = app.textFields["totalAmountTextField"]
        clearTextField(textField: amountTextField)
        
        inputText(textFieldID: "totalAmountTextField", text: "30")
        
        app.navigationBars["Edit Fuel"].buttons["Save"].tap()
        
        XCTAssert(app.staticTexts["30.00 €"].exists) 
    }
    
    func testNumberOfRowsFail() {
        app.launchArguments = ["-resetTable"]
        app.launch()
        
        XCTAssertEqual(app.tables.cells.count , 0)
    }
    
    
    // Helper to input text into a textfield with an identifier
    func addFuel() {        
        app.navigationBars["Fuel Register"].buttons["Add"].tap()
        
        inputText(textFieldID: "mileageTextField", text: "1000")
        inputText(textFieldID: "quantityTextField", text: "50")
        inputText(textFieldID: "totalAmountTextField", text: "100")
        XCUIApplication().navigationBars["Add Fuel"].buttons["Save"].tap()
    }
    
    func inputText(textFieldID: String, text: String) {
        let textField = app.textFields[textFieldID]
        textField.tap()
        
        textField.typeText(text)
    }
    
    func clearTextField(textField: XCUIElement) {
        textField.tap()
        textField.tap()
        app/*@START_MENU_TOKEN@*/.menuItems["Select All"]/*[[".menus.menuItems[\"Select All\"]",".menuItems[\"Select All\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.menuItems["Cut"]/*[[".menus.menuItems[\"Cut\"]",".menuItems[\"Cut\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
    }
}
