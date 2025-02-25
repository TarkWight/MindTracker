//
//  Coordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    
    var navigationController: UINavigationController { get set }
    
    func start(animated: Bool)
    
    func popViewCintroller(animated: Bool, transitionType: CATransitionType)
}

extension Coordinator {
    
    func popViewController(animated: Bool, useCustomAnmation: Bool = false, transitionType: CATransitionType = .push) {
        if useCustomAnmation {
            navigationController.customPopViewController(transitionType: transitionType)
        } else {
            navigationController.popViewController(animated: animated)
        }
    }
    
}
        

