//
//  ViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation
import UIKit

@MainActor
protocol ViewModel: AnyObject {
    associatedtype Event

    func handle(_ event: Event)
}
