//
//  AddNoteViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit
import Combine

final class AddNoteViewController: UIViewController, DisposableViewController {
    private let viewModel: AddNoteViewModel
    private let emotionsGridView = EmotionGridView()
    private let confirmButton = ConfirmButton()

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: AddNoteViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background

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
        backButton.setImage(AppIcons.arrowLeft, for: .normal)
        backButton.tintColor = AppColors.appWhite
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
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
        viewModel.$selectedEmotion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] emotion in
                if let emotion {
                    self?.confirmButton.updateState(for: emotion.type)
                    self?.confirmButton.isEnabled = true
                } else {
                    self?.confirmButton.isEnabled = false
                }
            }
            .store(in: &cancellables)
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
