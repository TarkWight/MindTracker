//
//  WeekFilterViewDelegate.swift
//  MindTracker
//
//  Created by Tark Wight on 03.03.2025.
//


import UIKit

protocol WeekFilterViewDelegate: AnyObject {
    func didSelectWeek(_ week: DateInterval)
}

