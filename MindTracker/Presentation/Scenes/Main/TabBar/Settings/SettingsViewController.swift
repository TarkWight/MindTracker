//
//  SettingsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//


import UIKit

final class SettingsViewController: UIViewController {
     let viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
    }
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
