//
//  AddNoteViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//


import UIKit

final class AddNoteViewController: UIViewController, DisposableViewController {
    private let viewModel: AddNoteViewModel

    init(viewModel: AddNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Add Note"
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save Note", for: .normal)
        saveButton.addTarget(self, action: #selector(saveNoteTapped), for: .touchUpInside)

        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func saveNoteTapped() {
        viewModel.handle(.saveNote)
    }
    
    func cleanUp() {
        viewModel.coordinator?.coordinatorDidFinish()
    }
    
    
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
