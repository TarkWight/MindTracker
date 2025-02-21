//
//  ViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

@MainActor
protocol ViewModel<Event>: AnyObject {
    associatedtype Event
    
    func handle(_ event: Event)
    
    
}
