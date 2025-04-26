//
//  LocalizedKey.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

enum LocalizedKey {

    // MARK: - Auth
    static let authTitle = NSLocalizedString("authTitle", comment: "Entry screen label")
    static let authButtonTitle = NSLocalizedString("authButtonTitle", comment: "Entry screen button")

    // MARK: - TabBar
    static let tabBarSettings = NSLocalizedString("settings", comment: "Settings tab bar item title")
    static let tabBarJournal = NSLocalizedString("tabBarJournal", comment: "Journal tab bar item title")
    static let tabBarStatistics = NSLocalizedString("tabBarStatistics", comment: "Statistics tab bar item title")

    // MARK: - Settings
    static let settingsViewTitle = NSLocalizedString("settings", comment: "Settings view title") // Дубликат с tabBarSettings
    static let settingsUserName = NSLocalizedString("userName", comment: "User name placeholder")
    static let settingsReminderSwitch = NSLocalizedString("remainder", comment: "Reminder settings title")
    static let settingsAddReminderButton = NSLocalizedString("remainderButton", comment: "Add reminder button")
    static let settingsFaceIdSwitch = NSLocalizedString("faceID", comment: "Face ID settings title")

    // MARK: - Journal
    static let journalTitle = NSLocalizedString("journalTitle", comment: "Journal view title")
    static let journalAddNoteButton = NSLocalizedString("addNote", comment: "Add note button")

    // MARK: - Journal - Stats
    static let journalTotalNotes = NSLocalizedString("totalNotes", comment: "Total notes count")
    static let journalTotalNotesFew = NSLocalizedString("totalNotes_few", comment: "Total notes count (few)")
    static let journalTotalNotesMany = NSLocalizedString("totalNotes_many", comment: "Total notes count (many)")

    static let journalNotesPerDay = NSLocalizedString("notesPerDay", comment: "Notes per day")
    static let journalNotesPerDayFew = NSLocalizedString("notesPerDay_few", comment: "Notes per day (few)")
    static let journalNotesPerDayMany = NSLocalizedString("notesPerDay_many", comment: "Notes per day (many)")

    static let journalStreak = NSLocalizedString("streak", comment: "Streak count")
    static let journalStreakFew = NSLocalizedString("streak_few", comment: "Streak count (few)")
    static let journalStreakMany = NSLocalizedString("streak_many", comment: "Streak count (many)")

    static let journalStreakDaysPredix = NSLocalizedString("streak_days", comment: "Streak days")
    static let journalPerDayPrefix = NSLocalizedString("per_day", comment: "Per day prefix")
    // MARK: - Statistics
    static let statisticsNoFrequentEmotions = NSLocalizedString("noFrequentEmotions", comment: "No frequent emotions")
    static let statisticsEmotionsOverview = NSLocalizedString("emotionsOverview", comment: "Emotions overview")
    static let statisticsRecords = NSLocalizedString("records", comment: "Count of records in statistics")
    static let statisticsEmotionsByDays = NSLocalizedString("emotionsByDays", comment: "Emotions by days")
    static let statisticsFrequentEmotions = NSLocalizedString("frequentEmotions", comment: "Frequent emotions")
    static let statisticsMoodOverTime = NSLocalizedString("moodOverTime", comment: "Mood over time")

    // MARK: - Add / Save Note
    static let addNoteConfirmButton = NSLocalizedString("confirmButtonS1", comment: "Confirm button")

    static let saveNoteTitle = NSLocalizedString("saveNoteTitle", comment: "Save note title")
    static let saveNoteActivity = NSLocalizedString("activity", comment: "Activity label text (note settings)")
    static let saveNotePeople = NSLocalizedString("people", comment: "People label text (note settings)")
    static let saveNoteLocation = NSLocalizedString("location", comment: "Location label text (note settings)")
    static let saveNoteSaveButton = NSLocalizedString("saveButton", comment: "Save button")

    // MARK: - Tags
    static let tagEating = NSLocalizedString("tag_eating", comment: "Eating activity")
    static let tagMeetingFriends = NSLocalizedString("tag_meeting_friends", comment: "Meeting friends activity")
    static let tagSport = NSLocalizedString("tag_sport", comment: "Sport activity")
    static let tagHobby = NSLocalizedString("tag_hobby", comment: "Hobby activity")
    static let tagRest = NSLocalizedString("tag_rest", comment: "Rest activity")
    static let tagTravel = NSLocalizedString("tag_travel", comment: "Travel activity")

    static let tagAlone = NSLocalizedString("tag_alone", comment: "Being alone")
    static let tagFriends = NSLocalizedString("tag_friends", comment: "Being with friends")
    static let tagFamily = NSLocalizedString("tag_family", comment: "Being with family")
    static let tagCoworkers = NSLocalizedString("tag_coworkers", comment: "Being with coworkers")
    static let tagPartner = NSLocalizedString("tag_partner", comment: "Being with partner")
    static let tagPets = NSLocalizedString("tag_pets", comment: "Being with pets")

    static let tagHome = NSLocalizedString("tag_home", comment: "At home")
    static let tagWork = NSLocalizedString("tag_work", comment: "At work")
    static let tagSchool = NSLocalizedString("tag_school", comment: "At school")
    static let tagTransport = NSLocalizedString("tag_transport", comment: "In transport")
    static let tagOutside = NSLocalizedString("tag_outside", comment: "Outside")

    // MARK: - Emotions
    static let emotionCard = NSLocalizedString("I_feel", comment: "Emotion card title")

    enum EmotionsDate {
        static let today = NSLocalizedString("today", comment: "Today")
        static let yesterday = NSLocalizedString("yesterday", comment: "Yesterday")
    }

    enum EmotionCategory {
        static let red = NSLocalizedString("red", comment: "Red category")
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
