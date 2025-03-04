//
//  DisposableViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Foundation

@MainActor
protocol DisposableViewController: NSObjectProtocol {
    func cleanUp()
}
