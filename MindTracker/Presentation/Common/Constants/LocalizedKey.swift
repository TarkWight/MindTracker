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
        static let statistics = NSLocalizedString("statistics", comment: "Statistics tab bar item title")
        
    }
    
    
        
   
   
}

// MARK: - Settings
extension LocalizedKey {
    enum Settings {
        static let title = NSLocalizedString("settings", comment: "Settings view title")
        
        static let userName = NSLocalizedString("userName", comment: "User name placeholder")
        static let remainderSwitch = NSLocalizedString("remainder", comment: "Remainder settings title")
        static let addRemainderButton = NSLocalizedString("remainderButton", comment: "Add remainder button")
        static let faceIdSwitch = NSLocalizedString("faceID", comment: "Face ID settings title")
    }
    
    
}

// MARK: - Journal
extension LocalizedKey {
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

// MARK: - Statistics

extension LocalizedKey {
    enum Statistics {
        static let emotionsOverview = NSLocalizedString("emotionsOverview", comment: "Emotions overview")
        static let emotionsByDays = NSLocalizedString("emotionsByDays", comment: "Emotions by days")
        static let frequentEmotions = NSLocalizedString("frequentEmotions", comment: "Frequent emotions")
        static let moodOverTime = NSLocalizedString("moodOverTime", comment: "Mood over time")
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
    
    
    
}

extension LocalizedKey {
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

    enum EmotionDescription {
        static let rage = NSLocalizedString("rage_description", comment: "Feeling of strong anger")
        static let tension = NSLocalizedString("tension_description", comment: "Feeling of stress and pressure")
        static let envy = NSLocalizedString("envy_description", comment: "Feeling of jealousy and comparison")
        static let anxiety = NSLocalizedString("anxiety_description", comment: "Feeling of worry and nervousness")

        static let excitement = NSLocalizedString("excitement_description", comment: "Feeling of enthusiasm and thrill")
        static let delight = NSLocalizedString("delight_description", comment: "Feeling of great pleasure and joy")
        static let confidence = NSLocalizedString("confidence_description", comment: "Feeling of self-assurance")
        static let happiness = NSLocalizedString("happiness_description", comment: "Feeling of contentment and joy")

        static let burnout = NSLocalizedString("burnout_description", comment: "Feeling of exhaustion from overwork")
        static let fatigue = NSLocalizedString("fatigue_description", comment: "Feeling of tiredness and lack of energy")
        static let depression = NSLocalizedString("depression_description", comment: "Feeling of deep sadness and hopelessness")
        static let apathy = NSLocalizedString("apathy_description", comment: "Feeling of lack of interest and motivation")

        static let calmness = NSLocalizedString("calmness_description", comment: "Feeling of peace and relaxation")
        static let satisfaction = NSLocalizedString("satisfaction_description", comment: "Feeling of contentment with achievements")
        static let gratitude = NSLocalizedString("gratitude_description", comment: "Feeling of appreciation and thankfulness")
        static let security = NSLocalizedString("security_description", comment: "Feeling of safety and stability")
    }
}

extension LocalizedKey {
    enum AddNote {
        static let confirmButton = NSLocalizedString("confirmButtonS1", comment: "Confirm button")
    }
    
    enum SaveNote {
        static let title = NSLocalizedString("saveNoteTitle", comment: "Save note title")
        
        static let activity = NSLocalizedString("activity", comment: "Activity label text (note settings)")
        static let people = NSLocalizedString("people", comment: "People label text (note settings)")
        static let location = NSLocalizedString("location", comment: "Location label text (note settings)")
        
        static let saveButton = NSLocalizedString("saveButton", comment: "Save button")
    }
}

extension LocalizedKey {
    enum Tags {
        enum activity {
            static let eating = NSLocalizedString("tag_eating", comment: "Прием пищи")
            static let meetingFriends = NSLocalizedString("tag_meeting_friends", comment: "Встреча с друзьями")
            static let sport = NSLocalizedString("tag_sport", comment: "Тренировка")
            static let hobby = NSLocalizedString("tag_hobby", comment: "Хобби")
            static let rest = NSLocalizedString("tag_rest", comment: "Отдых")
            static let travel = NSLocalizedString("tag_travel", comment: "Поездка")
        }

        enum people {
            static let alone = NSLocalizedString("tag_alone", comment: "Один")
            static let friends = NSLocalizedString("tag_friends", comment: "Друзья")
            static let family = NSLocalizedString("tag_family", comment: "Семья")
            static let coworkers = NSLocalizedString("tag_coworkers", comment: "Коллеги")
            static let partner = NSLocalizedString("tag_partner", comment: "Партнёр")
            static let pets = NSLocalizedString("tag_pets", comment: "Питомцы")
        }

        enum location {
            static let home = NSLocalizedString("tag_home", comment: "Дом")
            static let work = NSLocalizedString("tag_work", comment: "Работа")
            static let school = NSLocalizedString("tag_school", comment: "Школа")
            static let transport = NSLocalizedString("tag_transport", comment: "Транспорт")
            static let outside = NSLocalizedString("tag_outside", comment: "Улица")
        }
    }
}
