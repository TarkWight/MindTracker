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
    // MARK: - Coordinator Functions

    func addChild(_ child: Coordinator?) {
        if let child = child {
            childCoordinators.append(child)
        }
    }

    func childDidFinish(_ child: Coordinator?) {
        if let child = child {
            if let index = childCoordinators.firstIndex(where: { $0 === child }) {
                childCoordinators.remove(at: index)
            }
        }
    }
}
