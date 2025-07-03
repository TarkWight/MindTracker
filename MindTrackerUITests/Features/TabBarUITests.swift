//
//  TabBarUITests.swift
//  MindTracker
//
//  Created by Tark Wight on 03.07.2025.
//

import XCTest

final class TabBarUITests: BaseUITest {

    // MARK: - Проверка, что TabBar появился

    func testTabBarIsPresent() {
        let tabBar = app.tabBars["main_tabbar"]
        let exists = tabBar.waitForExistence(timeout: 3)
        print("[TEST] TabBar найден: \(exists)")
        XCTAssertTrue(exists, "TabBar должен быть видим")
    }

    // MARK: - Проверка, что кнопки TabBar присутствуют

    func testTabButtonsExist() {
        let tabBar = app.tabBars["main_tabbar"]

        let journalTab = tabBar.buttons["tab_journal"]
        let statisticsTab = tabBar.buttons["tab_statistics"]
        let settingsTab = tabBar.buttons["tab_settings"]

        let journalExists = journalTab.waitForExistence(timeout: 3)
        let statisticsExists = statisticsTab.waitForExistence(timeout: 3)
        let settingsExists = settingsTab.waitForExistence(timeout: 3)

        print("[TEST] journalTab.exists = \(journalExists)")
        print("[TEST] statisticsTab.exists = \(statisticsExists)")
        print("[TEST] settingsTab.exists = \(settingsExists)")

        XCTAssertTrue(journalExists, "Кнопка Journal должна быть доступна")
        XCTAssertTrue(statisticsExists, "Кнопка Statistics должна быть доступна")
        XCTAssertTrue(settingsExists, "Кнопка Settings должна быть доступна")
    }

    // MARK: - Проверка переключения между вкладками и отображения соответствующих экранов

    func testTabSwitching() {
        let journalTab = app.tabBars.buttons["tab_journal"]
        let statisticsTab = app.tabBars.buttons["tab_statistics"]
        let settingsTab = app.tabBars.buttons["tab_settings"]

        // Statistics
        XCTAssertTrue(statisticsTab.waitForExistence(timeout: 3), "Statistics tab не найдена")
        statisticsTab.tap()
        XCTAssertTrue(app.otherElements["tab_statistics_vc"].waitForExistence(timeout: 3), "Не найден экран Statistics")
        print("[TEST] Выбрана Statistics")

        // Settings
        settingsTab.tap()
        XCTAssertTrue(app.otherElements["tab_settings_vc"].waitForExistence(timeout: 3), "Не найден экран Settings")
        print("[TEST] Выбрана Settings")

        // Journal
        journalTab.tap()
        XCTAssertTrue(app.otherElements["tab_journal_vc"].waitForExistence(timeout: 3), "Не найден экран Journal")
        print("[TEST] Выбрана Journal")
    }
}
