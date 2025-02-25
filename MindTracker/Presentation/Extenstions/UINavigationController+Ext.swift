//
//  UINavigationController+Ext.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

private let _durationTime: CFTimeInterval = 0.25

public extension UINavigationController {
    
    enum VCTransition {
        case fromTop
        case fromBottom
    }
    
    func customPopViewController(direction: VCTransition = .fromTop, transitionType: CATransitionType = .push) {
        self.addTransition(transitionDirection: direction, transitionType: transitionType)
        self.popViewController(animated: false)
    }
        
    private func addTransition(transitionDirection direction: VCTransition, transitionType: CATransitionType = .push, duration: CFTimeInterval = _durationTime) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = transitionType
        transition.timingFunction = .init(name: .easeInEaseOut)
        if direction == .fromBottom {
            transition.subtype = .fromBottom
        } else {
            transition.subtype = .fromTop
        }
        self.view.layer.add(transition, forKey: kCATransition)
    }
        
}
