//
//  JournalViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//


import UIKit

final class JournalViewController: UIViewController, DisposableViewController {
    let viewModel: JournalViewModel

    init(viewModel: JournalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Journal"
        
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Note", for: .normal)
        addButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)

        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        view.addSubview(addButton)
        view.addSubview(saveButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20)
        ])
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
          cleanUp()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.coordinator?.cleanUpZombieCoordinators()
    }
    
    @objc private func addNoteTapped() {
        viewModel.handle(.addNote)
    }
    
    @objc private func saveTapped() {
        viewModel.handle(.didNoteSelected)
    }
    
    func cleanUp() {
        viewModel.coordinator?.coordinatorDidFinish()
    }
    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
