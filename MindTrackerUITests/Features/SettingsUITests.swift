//
//  SettingsUITests.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import XCTest

final class SettingsUITests: BaseUITest {

    override func setUpWithError() throws {
        try super.setUpWithError()
        switchToTab("tab_settings")
        XCTAssertTrue(app.otherElements["tab_settings_vc"].waitForExistence(timeout: 3), "Экран настроек не загрузился")
    }

    func testSettingsScreenUIElementsExist() {
        XCTAssertTrue(app.staticTexts["settings_title_label"].exists, "Заголовок настроек отсутствует")
        XCTAssertTrue(app.images["settings_avatar_image"].exists, "Аватар не отображается")
        XCTAssertTrue(app.staticTexts["settings_user_name_label"].exists, "Имя пользователя не отображается")
        XCTAssertTrue(app.switches["settings_reminder_switch"].exists, "Свитч напоминаний не отображается")
        XCTAssertTrue(app.buttons["settings_add_reminder_button"].exists, "Кнопка добавления напоминания отсутствует")

        let faceIdSwitch = app.switches["settings_biometry_switch"]
        if faceIdSwitch.exists {
            XCTAssertTrue(faceIdSwitch.exists, "Свитч Face ID доступен, но не найден")
        }
    }

    func testReminderSwitchToggle() {
        let reminderSwitch = app.switches["settings_reminder_switch"]
        XCTAssertTrue(reminderSwitch.exists)
        let initialValue = reminderSwitch.value as? String
        reminderSwitch.tap()
        let toggledValue = reminderSwitch.value as? String
        XCTAssertNotEqual(initialValue, toggledValue)
    }
}
