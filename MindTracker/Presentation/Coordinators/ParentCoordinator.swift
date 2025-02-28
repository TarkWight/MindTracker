//
//  ParentCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

@MainActor
protocol ParentCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    
    func addChild(_ child: Coordinator?)
    
    func childDidFinish(_ child: Coordinator?)

}

extension ParentCoordinator {
    //MARK: - Coordinator Functions
    func addChild(_ child: Coordinator?) {
        if let _child = child {
            childCoordinators.append(_child)
        }
    }
 
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
}
