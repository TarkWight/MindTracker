//
//  UITheme.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

enum UITheme {
    private static func customFont(name: String, size: CGFloat) -> UIFont {
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    enum Font {
        enum AuthScene {
            static let title = customFont(name: "Gwen-Trial", size: 48)
            static let googleButton = customFont(name: "VelaSans-GX", size: 16)
        }
        
        enum JournalScene {
            static let title = customFont(name: "Gwen-Trial", size: 36)
            static let addNoteButton = customFont(name: "VelaSans-GX", size: 16)
        }
        
        enum StatisticsScene {
            static let title = customFont(name: "Gwen-Trial", size: 36)
            static let categorySubtitle = customFont(name: "VelaSans-GX", size: 20)
            static let weekCell = customFont(name: "VelaSans-GX", size: 16)
            
            static let dayTitle = customFont(name: "VelaSans-GX", size: 12)
            static let dayDate = customFont(name: "VelaSans-GX", size: 12)
            static let emotionTitle = customFont(name: "VelaSans-GX", size: 12)
        }
        
        enum SettingsScene {
            static let title = customFont(name: "Gwen-Trial", size: 44)
            static let username = customFont(name: "VelaSans-GX", size: 24)
            
            static let remindersTitle = customFont(name: "VelaSans-GX", size: 16)
            static let timerTitle = customFont(name: "VelaSans-GX", size: 16)
            static let addReminderButton = customFont(name: "VelaSans-GX", size: 16)
            static let loginSwitchTitle = customFont(name: "VelaSans-GX", size: 16)
            
            static let categoryPersent = customFont(name: "VelaSans-GX", size: 20)
        }
        
        enum AddNote {
            static let confirmButtonS1 = customFont(name: "VelaSans-GX", size: 12)
            static let confirmButtonS2 = customFont(name: "VelaSans-GX", size: 12)
            static let emotionCell = customFont(name: "GwenText-Trial-Bold", size: 10)
        }
        
        enum SaveNote {
            static let title = customFont(name: "Gwen-Trial", size: 24)
            static let label = customFont(name: "VelaSans-GX", size: 16)
            static let saveButton = customFont(name: "VelaSans-GX", size: 16)
        }
        
        enum EmotionCard {
            static let date = customFont(name: "VelaSans-GX", size: 14)

            static let label = customFont(name: "VelaSans-GX", size: 20)
            static let title = customFont(name: "Gwen-Trial", size: 28)
        }
        
    }
    
    enum Icons {
        enum AuthScene {
            static let google = UIImage(named: "GoogleIcon")
            static let apple = UIImage(named: "AppleIcon")
        }
        
        enum SettingsScene {
            static let reminders = UIImage(named: "Alert On")
            static let delete = UIImage(named: "Delete")
            static let timer = UIImage(named: "Timer")
            static let fingerPrint = UIImage(named: "Fingerprint")
            static let faceId = UIImage(named: "FaceId")
            static let profilePlaceholder = UIImage(named: "profile")
        }
        
        enum tabBar {
            static let journal = UIImage(named: "JournalIcon")
            static let settings = UIImage(named: "SettingsIcon")
            static let statistics = UIImage(named: "StatisticsIcon")
        }
        
        enum EmotionCard {
            static let redIcon = UIImage(named: "EmotionRed")
            static let greenIcon = UIImage(named: "EmotionGreen")
            static let blueIcon = UIImage(named: "EmotionBlue")
            static let yellowIcon = UIImage(named: "EmotionYellow")
            static let placeholder = UIImage(named: "EmotionPlaceholder")
        }
        
        enum Navigation {
            static let arrowRight = UIImage(named: "Arrow Right")
            static let back = UIImage(named: "NavBack")
        }
    }
    
    enum Colors {
        static let background: UIColor = .appBlack
        
        static let appWhite: UIColor = .appWhite
        static let appBlack: UIColor = .appBlack
        static let appGray: UIColor = .appGray
        static let appGrayLight: UIColor = .appGrayLight
        static let appGrayFaded: UIColor = .appGrayFaded
        static let appGreen: UIColor = .appGreen
        
        static let emotionCardRed: UIColor = .emotionCardRed
        static let emotionCardGreen: UIColor = .emotionCardGreen
        static let emotionCardBlue: UIColor = .emotionCardBlue
        static let emotionCardYellow: UIColor = .emotionCardYellow
    }
}
