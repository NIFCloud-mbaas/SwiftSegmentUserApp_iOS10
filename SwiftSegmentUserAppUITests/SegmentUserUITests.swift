//
//  SwiftSegmentUserAppUITests.swift
//  SwiftSegmentUserAppUITests
//
//  Created by HungNV on 4/14/21.
//  Copyright © 2021 NIFTY Corporation. All rights reserved.
//

import XCTest

class SegmentUserUITests: XCTestCase {
    
    var app: XCUIApplication!
    var tfUsername: XCUIElement!
    var tfPassword: XCUIElement!
    var btnLogin: XCUIElement!
    var btnLogout: XCUIElement!
    var cell: XCUIElement!
    var tfKey: XCUIElement!
    var tfValue: XCUIElement!
    var btnSave: XCUIElement!
    let strKey = "KeyTest"
    let strValue = "ValueTest"
    
    // MARK: - Setup for UI Test
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        tfUsername = app.textFields["tfUsername"]
        tfPassword = app.secureTextFields["tfPassword"]
        btnLogin = app.buttons["btnLogin"]
        btnLogout = app.buttons["btnLogout"]
        cell = app.cells.element(matching: .cell, identifier: "addCell")
        tfKey = cell.textFields["tfKey"]
        tfValue = cell.textFields["tfValue"]
        btnSave = cell.buttons["btnSave"]
    }
    
    func testSegmentUserScreen() throws {
        app.launch()
        tfUsername.tap()
        tfUsername.typeText("Hoge")
        tfPassword.tap()
        tfPassword.typeText("123456")
        btnLogin.tap()
        XCTAssertTrue(app.staticTexts["SegmentUserApp"].waitForExistence(timeout: 10))
        scrollToLastCell()
        tfKey.tap()
        tfKey.typeText(strKey)
        tfKey.tap(button: "return")
        tfValue.tap()
        tfValue.typeText(strValue)
        tfValue.tap(button: "return")
        btnSave.tap()
        scrollToLastCell()
        let strKey = app.filterCells(containing: self.strKey).element
        XCTAssertTrue(strKey.waitForExistence(timeout: 180))
        let strValue = app.filterCells(containing: self.strKey).element
        XCTAssertTrue(strValue.waitForExistence(timeout: 180))
        XCTAssert(btnLogout.exists)
        btnLogout.tap()
    }
    
    private func scrollToLastCell() {
        let table = app.tables.element(boundBy: 0)
        let lastCell = table.cells.element(boundBy: table.cells.count-1)
        table.scrollToElement(element: lastCell)
    }
}

// MARK: - XCUIApplication
extension XCUIApplication {
    // Filter cells in TableView
    func filterCells(containing labels: String...) -> XCUIElementQuery {
        var cells = self.cells
        for label in labels {
            cells = cells.containing(NSPredicate(format: "label CONTAINS %@", label))
        }
        return cells
    }
}

extension XCUIElement {
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard self.exists && !self.frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(self.frame)
    }
    
    func tap(button: String) {
        XCUIApplication().keyboards.buttons[button].tap()
    }
}
