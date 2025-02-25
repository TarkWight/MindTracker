//
//  ParentCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

protocol ParentCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    
    func addChildCoordinator(_ childCoordinator: Coordinator?)
    
    func childDidFinish(_ childCoordinator: Coordinator?)
}
