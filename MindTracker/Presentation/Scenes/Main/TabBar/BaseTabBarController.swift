//
//  BaseTabBarController.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import Foundation
import UIKit

final class BaseTabBarController: UITabBarController {
    weak var coordinator: RootCoordinator?
    
    private let authCoordinator = AuthCoordinator(navigationController: UINavigationController())
    private let joutnalCoordinator = JournalCoordinator(navigationController: UINavigationController())
    private let statisticsCoordinator = StatisticsCoordinator(navigationController: UINavigationController())
    private let settingsCoordinator = SettingsCoordinator(navigationController: UINavigationController())
    
    private let addNoteCoordinator = AddNoteCoordinator(navigationController: UINavigationController())
    private let noteSettingsCoordinator = NoteSettingsCoordinator(navigationController: UINavigationController())
    
    private (set) var initCoordinators = [Coordinator]()
    
    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: "BaseTabBarController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        
        authCoordinator.parent = coordinator
        joutnalCoordinator.parent = coordinator
        addNoteCoordinator.parent = coordinator
        noteSettingsCoordinator.parent = coordinator
        statisticsCoordinator.parent = coordinator
        settingsCoordinator.parent = coordinator
       
        for item in [joutnalCoordinator, addNoteCoordinator] {
            coordinator?.addChild(item as? Coordinator)
        }
        
        authCoordinator.start()
        joutnalCoordinator.start()
        addNoteCoordinator.start()
        noteSettingsCoordinator.start()
        statisticsCoordinator.start()
        settingsCoordinator.start()

        initCoordinators = coordinator?.childCoordinators ?? []
        viewControllers = [joutnalCoordinator.navigationController, statisticsCoordinator.navigationController, settingsCoordinator.navigationController]
    }
    
    /// Hides BaseTabBarViewController's navigation controller
    func hideNavigationController() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
//    func cleanUpMerch() {
//        merchCoordinator.dismissMerchScreens()
//    }
    
    func cleanUpZombieCoordinators() {
        /// Since the `MerchCoordinator` could be initialized from only two places we can assume every other instance of it
        /// existing inside the `childCoordinators` belongs to the `GreenViewController` and is safe to be removed.
        
        if let currentCoordinators = coordinator?.childCoordinators {
            for item in currentCoordinators {
                let contains = initCoordinators.contains(where: {$0 === item})
                if contains == false {
                    /// Dismissing newly `MerchCoordinator` children coordinators
//                    if let merch
//                        Coordinator = item as? MerchCoordinator {
//                        merchCoordinator.dismissMerchScreens()
//                        coordinator?.childDidFinish(merchCoordinator)
//                    }
                    
                    /// Removing the `BlueCoordinator` which was added throught the `GreenViewController`
//                    if let blueCoordinator = item as? BlueCoordinator, let viewController = blueCoordinator.viewControllerRef as? DisposableViewController {
//                        viewController.cleanUp()
//                        blueCoordinator.viewControllerRef?.navigationController?.popViewController(animated: false)
//                        coordinator?.childDidFinish(blueCoordinator)
//                    }
                }
            }
        }
    }
    
}
