//
//  ConsoleLogger.swift
//  MindTracker
//
//  Created by Tark Wight on 26.02.2025.
//

import Foundation
import OSLog

enum ConsoleLogger {
    static func log(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
            let fileURL = URL(fileURLWithPath: file)
            let pathExtension = fileURL.pathExtension
            let fileName = "\(URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent).\(pathExtension)"
            let logMessage = "\(message): \(fileName), \(function) line #\(line)"
            os_log("%{public}@", log: .default, type: .info, logMessage)
        #endif
    }

    static func classDeInitialized(file: String = #file) {
        #if DEBUG
            let fileURL = URL(fileURLWithPath: file)
            let pathExtension = fileURL.pathExtension
            let fileName = "\(URL(fileURLWithPath: file).deletingPathExtension().lastPathComponent).\(pathExtension)"
            print("\(fileName) is de-initialized.")
        #endif
    }
}
