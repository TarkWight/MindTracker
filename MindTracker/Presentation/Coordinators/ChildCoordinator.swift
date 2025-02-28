//
//  ChildCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

@MainActor
protocol ChildCoordinator: Coordinator {
    
    func coordinatorDidFinish()
    
    var viewControllerRef: UIViewController? { get set }
    
}
