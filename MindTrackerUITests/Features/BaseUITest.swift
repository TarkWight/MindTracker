//
//  BaseUITest.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import XCTest

class BaseUITest: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchEnvironment["UITEST_SKIP_LOGIN"] = "true"
        app.launch()

        try performLoginIfNeeded()
    }

    func performLoginIfNeeded() throws {
        let loginButton = app.buttons["auth_login_button"]

        if loginButton.waitForExistence(timeout: 3) {
            loginButton.tap()

            let webView = app.webViews["auth_web_view"]
            XCTAssertTrue(webView.waitForExistence(timeout: 3), "WebView не появился после нажатия на логин")

            let tabBar = app.tabBars["main_tabbar"]
            XCTAssertTrue(tabBar.waitForExistence(timeout: 6), "TabBar не появился после логина")
        }
    }

    func switchToTab(_ identifier: String, timeout: TimeInterval = 3) {
        let tab = app.tabBars.buttons[identifier]
        XCTAssertTrue(tab.waitForExistence(timeout: timeout), "Tab \(identifier) не найден")
        tab.tap()
    }
}
