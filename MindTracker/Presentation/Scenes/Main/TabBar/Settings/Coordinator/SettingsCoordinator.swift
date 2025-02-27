//
//  SettingsCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//


import Foundation
import UIKit

final class SettingsCoordinator: Coordinator {

    var parent: RootCoordinator?
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(animated: Bool = false) {
    }
    
}


