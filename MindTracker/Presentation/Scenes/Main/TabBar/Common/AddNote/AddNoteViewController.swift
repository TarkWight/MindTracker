//
//  AddNoteViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

final class AddNoteViewController: UIViewController, DisposableViewController {
    private let viewModel: AddNoteViewModel
    private let emotionsGridView = EmotionGridView()
    private let confirmButton = ConfirmButton()

    init(viewModel: AddNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UITheme.Colors.background

        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupUI() {
        emotionsGridView.onEmotionSelected = { [weak self] emotion in
            self?.viewModel.handle(.selectEmotion(emotion))
        }

        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)

        view.addSubview(emotionsGridView)
        view.addSubview(confirmButton)
    }

    private func setupNavigationBar() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UITheme.Icons.Navigation.back, for: .normal)
        backButton.tintColor = UITheme.Colors.appWhite
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupConstraints() {
        emotionsGridView.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emotionsGridView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emotionsGridView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emotionsGridView.widthAnchor.constraint(equalToConstant: 460),
            emotionsGridView.heightAnchor.constraint(equalToConstant: 460),

            confirmButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            confirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }

    private func setupBindings() {
        viewModel.onEmotionSelected = { [weak self] emotion in
            self?.confirmButton.updateState(for: emotion)
        }
    }

    @objc private func backTapped() {
        viewModel.handle(.dismiss)
    }

    @objc private func confirmTapped() {
        viewModel.handle(.confirmSelection)
    }

    func cleanUp() {
        viewModel.coordinator?.coordinatorDidFinish()
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
