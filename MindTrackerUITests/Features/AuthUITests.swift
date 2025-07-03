//
//  AuthUITests.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import XCTest

final class AuthUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    // MARK: - 0. Проверка, что контейнер авторизации отображается

    func testAuthContainerExists() {
        let container = app.otherElements["auth_container_view"]
        XCTAssertTrue(container.waitForExistence(timeout: 2), "Контейнер экрана логина должен отображаться")
    }

    // MARK: - 1. Проверка, что экран логина отображается

    func testAuthScreenExists() {
        let loginTitle = app.staticTexts["auth_title_label"]
        XCTAssertTrue(loginTitle.exists, "Заголовок логина должен отображаться")
    }

    // MARK: - 2. Проверка наличия кнопки логина

    func testLoginButtonExists() {
        let loginButton = app.buttons["auth_login_button"]
        XCTAssertTrue(loginButton.exists, "Кнопка логина должна отображаться")
    }

    // MARK: - 3. Проверка, что при нажатии на кнопку логина открывается WebView

    func testLoginButtonOpensWebView() {
        let loginButton = app.buttons["auth_login_button"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 4), "Кнопка логина должна быть доступна")

        loginButton.tap()

        let webView = app.webViews["auth_web_view"]
        XCTAssertTrue(webView.waitForExistence(timeout: 6), "WebView должен появиться после нажатия на логин")
    }
}
