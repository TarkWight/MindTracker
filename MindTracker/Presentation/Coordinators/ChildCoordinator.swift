//
//  ChildCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

protocol ChildCoordinator {
    
    func coordinatorDidFinish()
    
    var viewControllerRef: UIViewController { get set }
    
}
