//
//  LocalizedKey.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

enum LocalizedKey {
    enum AuthView {
        static let title = NSLocalizedString("authTitle", comment: "Entry screen label")
        static let buttonTitle = NSLocalizedString("authButtonTitle", comment: "Entry screen button")
    }
    
    enum TabBar {
        static let settings = NSLocalizedString("settings", comment: "Settings tab bar item title")
    }
    
    enum Settings {
        static let title = NSLocalizedString("settings", comment: "Settings tab bar item title")
        
        static let userName = NSLocalizedString("userName", comment: "User name placeholder")
        static let remainderSwitch = NSLocalizedString("remainder", comment: "Remainder settings title")
        static let addRemainderButton = NSLocalizedString("remainderButton", comment: "Add remainder button")
        static let faceIdSwitch = NSLocalizedString("faceID", comment: "Face ID settings title")
    }
    
    enum Journal {
        static let totalNotes = NSLocalizedString("totalNotes", comment: "Total notes count")
        static let totalNotesFew = NSLocalizedString("totalNotes_few", comment: "Total notes count (few)")
        static let totalNotesMany = NSLocalizedString("totalNotes_many", comment: "Total notes count (many)")

        static let notesPerDay = NSLocalizedString("notesPerDay", comment: "Notes per day")
        static let notesPerDayFew = NSLocalizedString("notesPerDay_few", comment: "Notes per day (few)")
        static let notesPerDayMany = NSLocalizedString("notesPerDay_many", comment: "Notes per day (many)")

        static let streak = NSLocalizedString("streak", comment: "Streak count")
        static let streakFew = NSLocalizedString("streak_few", comment: "Streak count (few)")
        static let streakMany = NSLocalizedString("streak_many", comment: "Streak count (many)")
    }
}

