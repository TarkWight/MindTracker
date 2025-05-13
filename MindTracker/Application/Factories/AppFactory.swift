//
//  AppFactory.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

final class AppFactory {
    lazy var avatarService = MockAvatarService()
    lazy var faceIDService = MockFaceIDService()
    lazy var reminderService = MockReminderService()
}
