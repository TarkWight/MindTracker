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

    func customPopViewController(
        direction: VCTransition = .fromTop,
        transitionType: CATransitionType = .push
    ) {
        addTransition(transitionDirection: direction, transitionType: transitionType)
        popViewController(animated: false)
    }

    func popToViewController(ofClass: AnyClass, animated: Bool) {
        if let viewController = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
            popToViewController(viewController, animated: animated)
        }
    }

    func customPopToRootViewController(
        direction: VCTransition = .fromTop,
        transitionType: CATransitionType = .push
    ) {
        addTransition(transitionDirection: direction, transitionType: transitionType)
        popToRootViewController(animated: false)
    }

    func customPopToViewController(
        viewController uivc: UIViewController,
        direction: VCTransition = .fromTop,
        transitionType: CATransitionType = .push
    ) {
        addTransition(transitionDirection: direction, transitionType: transitionType)
        popToViewController(uivc, animated: false)
    }

    func customPushViewController(
        viewController uivc: UIViewController,
        direction: VCTransition = .fromBottom,
        transitionType: CATransitionType = .push
    ) {
        addTransition(transitionDirection: direction, transitionType: transitionType)
        pushViewController(uivc, animated: false)
    }

    private func addTransition(
        transitionDirection direction: VCTransition,
        transitionType: CATransitionType = .push,
        duration: CFTimeInterval = _durationTime
    ) {
        let transition = CATransition()
        transition.duration = duration
        transition.type = transitionType
        transition.timingFunction = .init(name: .easeInEaseOut)
        if direction == .fromBottom {
            transition.subtype = .fromBottom
        } else {
            transition.subtype = .fromTop
        }
        view.layer.add(transition, forKey: kCATransition)
    }
}
