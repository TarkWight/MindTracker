//
//  StatisticsCoordinator.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//


import UIKit

@MainActor
protocol StatisticsCoordinatorProtocol: Coordinator {}
    
final class StatisticsCoordinator: StatisticsCoordinatorProtocol, ChildCoordinator {
    var navigationController: UINavigationController
    weak var parent: ParentCoordinator?
    var viewControllerRef: UIViewController?
    private let sceneFactory: SceneFactory

    init(navigationController: UINavigationController, parent: ParentCoordinator?, sceneFactory: SceneFactory) {
        self.navigationController = navigationController
        self.parent = parent
        self.sceneFactory = sceneFactory
    }

    func start(animated: Bool) {
        let statisticsVC = sceneFactory.makeStatisticsScene(coordinator: self)
        viewControllerRef = statisticsVC
        statisticsVC.viewModel.coordinator = self
        statisticsVC.tabBarItem = UITabBarItem(title: LocalizedKey.TabBar.statistics, image: UITheme.Icons.tabBar.statistics, selectedImage: nil)
        
        navigationController.pushViewController(statisticsVC, animated: animated)
    }

    func coordinatorDidFinish() {
        parent?.childDidFinish(self)
    }
}
