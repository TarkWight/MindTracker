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
        static let journal = NSLocalizedString("journal", comment: "Journal tab bar item title")
        
    }
    
    
        
    enum Settings {
        static let title = NSLocalizedString("settings", comment: "Settings view title")
        
        static let userName = NSLocalizedString("userName", comment: "User name placeholder")
        static let remainderSwitch = NSLocalizedString("remainder", comment: "Remainder settings title")
        static let addRemainderButton = NSLocalizedString("remainderButton", comment: "Add remainder button")
        static let faceIdSwitch = NSLocalizedString("faceID", comment: "Face ID settings title")
    }
    
    enum Journal {
        static let title = NSLocalizedString("journalTitle", comment: "Journal view title")
        static let addNoteButton = NSLocalizedString("addNote", comment: "Add note button")
        
        
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

// MARK: - Emotions
extension LocalizedKey {
    static let emotionCard = NSLocalizedString("I_feel", comment: "Emotion card title")
    
    enum EmotionsDate {
        static let today = NSLocalizedString("today", comment: "Today")
        static let yesterday = NSLocalizedString("yesterday", comment: "Yesterday")
    }
    
    enum EmotionCategory {
        static let red = NSLocalizedString("red" , comment: "Red category")
        static let yellow = NSLocalizedString("yellow", comment: "Yellow category")
        static let green = NSLocalizedString("green", comment: "Green category")
        static let blue = NSLocalizedString("blue", comment: "Blue category")
        
    }
    
    enum EmotionType {
        static let rage = NSLocalizedString("rage", comment: "Red emotion")
        static let tension = NSLocalizedString("tension", comment: "Red emotion")
        static let envy = NSLocalizedString("envy", comment: "Red emotion")
        static let anxiety = NSLocalizedString("anxiety", comment: "Red emotion")
        
        static let excitement = NSLocalizedString("excitement", comment: "Yellow emotion")
        static let delight = NSLocalizedString("delight", comment: "Yellow emotion")
        static let confidence = NSLocalizedString("confidence", comment: "Yellow emotion")
        static let happiness = NSLocalizedString("happiness", comment: "Yellow emotion")
        
        static let burnout = NSLocalizedString("burnout", comment: "Blue emotion")
        static let fatigue = NSLocalizedString("fatigue", comment: "Blue emotion")
        static let depression = NSLocalizedString("depression", comment: "Blue emotion")
        static let apathy = NSLocalizedString("apathy", comment: "Blue emotion")
        
        static let calmness = NSLocalizedString("calmness", comment: "Green emotion")
        static let satisfaction = NSLocalizedString("satisfaction", comment: "Green emotion")
        static let gratitude = NSLocalizedString("gratitude", comment: "Green emotion")
        static let security = NSLocalizedString("security", comment: "Green emotion")
    }
    
}
