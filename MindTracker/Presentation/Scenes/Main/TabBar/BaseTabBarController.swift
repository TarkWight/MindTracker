//
//  BaseTabBarController.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import UIKit

final class BaseTabBarController: UITabBarController {
    weak var coordinator: TabBarCoordinator?
    private let sceneFactory: SceneFactory

    var journalCoordinator: JournalCoordinator?
    private var statisticsCoordinator: StatisticsCoordinator?
    private var settingsCoordinator: SettingsCoordinator?

    private(set) var initCoordinators: [Coordinator] = []

    init(coordinator: TabBarCoordinator, sceneFactory: SceneFactory) {
        self.coordinator = coordinator
        self.sceneFactory = sceneFactory
        super.init(nibName: nil, bundle: nil)

        view.backgroundColor = AppColors.background
        setupCoordinators()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.accessibilityIdentifier = TabBarAccessibility.container
        tabBar.accessibilityIdentifier = TabBarAccessibility.tabBar
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        for (index, subview) in tabBar.subviews.enumerated() {
            guard let tabBarButton = subview as? UIControl else { continue }

            switch index {
            case 0:
                tabBarButton.accessibilityIdentifier = TabBarAccessibility.journalTab
            case 1:
                tabBarButton.accessibilityIdentifier = TabBarAccessibility.statisticsTab
            case 2:
                tabBarButton.accessibilityIdentifier = TabBarAccessibility.settingsTab
            default:
                break
            }
        }
    }

    private func setupCoordinators() {
        let journalNav = UINavigationController()
        let statisticsNav = UINavigationController()
        let settingsNav = UINavigationController()

        journalCoordinator = JournalCoordinator(
            navigationController: journalNav,
            parent: coordinator,
            sceneFactory: sceneFactory
        )

        statisticsCoordinator = StatisticsCoordinator(
            navigationController: statisticsNav,
            parent: coordinator,
            sceneFactory: sceneFactory
        )

        settingsCoordinator = SettingsCoordinator(
            navigationController: settingsNav,
            parent: coordinator,
            sceneFactory: sceneFactory
        )

        journalCoordinator?.start(animated: false)
        statisticsCoordinator?.start(animated: false)
        settingsCoordinator?.start(animated: false)

        guard let journalCoordinator, let statisticsCoordinator,
            let settingsCoordinator
        else {
            return
        }

        for item in [
            journalCoordinator, statisticsCoordinator, settingsCoordinator,
        ] as [Coordinator] {
            coordinator?.addChild(item)
        }

        initCoordinators = coordinator?.childCoordinators ?? []
        viewControllers = [
            journalCoordinator.navigationController,
            statisticsCoordinator.navigationController,
            settingsCoordinator.navigationController,
        ]

        journalNav.view.accessibilityIdentifier = TabBarAccessibility.journalTab
        statisticsNav.view.accessibilityIdentifier = TabBarAccessibility.statisticsTab
        settingsNav.view.accessibilityIdentifier = TabBarAccessibility.settingsTab
    }

    func hideNavigationController() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func cleanUpZombieCoordinators() {
        if let currentCoordinators = coordinator?.childCoordinators {
            for item in currentCoordinators {
                let contains = initCoordinators.contains(where: { $0 === item })

                if contains == false {
                    if let childCoordinator = item as? ChildCoordinator,
                        let viewController = childCoordinator.viewControllerRef
                            as? DisposableViewController {
                        viewController.cleanUp()
                        childCoordinator.viewControllerRef?
                            .navigationController?.popViewController(
                                animated: false
                            )
                    }

                    coordinator?.childDidFinish(item)
                }
            }
        }
    }
}

private enum TabBarAccessibility {
    static let container = "main_tabbar_container"
    static let tabBar = "main_tabbar"

    static let journalTab = "tab_journal"
    static let statisticsTab = "tab_statistics"
    static let settingsTab = "tab_settings"
}
