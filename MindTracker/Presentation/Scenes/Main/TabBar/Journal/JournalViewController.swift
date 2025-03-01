//
//  JournalViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 22.02.2025.
//

import UIKit

final class JournalViewController: UIViewController, DisposableViewController {
    let viewModel: JournalViewModel
    private let journalStatsView = JournalStatsView()

    let addButton = UIButton(type: .system)
    let saveButton = UIButton(type: .system)

    
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

        setupUI()
        setupConstraints()
        setupBindings()
    }

    private func setupUI() {
        view.addSubview(journalStatsView)

       
        addButton.setTitle("Add Note", for: .normal)
        addButton.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)

        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        view.addSubview(addButton)
        view.addSubview(saveButton)

        addButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupConstraints() {
        journalStatsView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Статистика сверху с отступом
            journalStatsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            journalStatsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Кнопки под статистикой
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.topAnchor.constraint(equalTo: journalStatsView.bottomAnchor, constant: 20),

            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20)
        ])
    }

    private func setupBindings() {
        viewModel.onStatsUpdated = { [weak self] totalNotes, notesPerDay, streak in
            self?.journalStatsView.update(totalNotesText: totalNotes, notesPerDayText: notesPerDay, streakText: streak)
        }
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
