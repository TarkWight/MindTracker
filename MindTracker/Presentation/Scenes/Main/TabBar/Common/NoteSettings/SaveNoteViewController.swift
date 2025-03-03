//
//  SaveNoteViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import UIKit

final class SaveNoteViewController: UIViewController, DisposableViewController {
    private let viewModel: SaveNoteViewModel

    private let titleLabel = UILabel()
    private let emotionCardView: EmotionCardView
    private let activityLabel = UILabel()
    private let peopleLabel = UILabel()
    private let locationLabel = UILabel()
    private let tagSectionActivity = TagCollectionView()
    private let tagSectionPeople = TagCollectionView()
    private let tagSectionLocation = TagCollectionView()
    private let saveButton = UIButton()

    init(viewModel: SaveNoteViewModel) {
        self.viewModel = viewModel
        self.emotionCardView = EmotionCardView(emotion: viewModel.getEmotionMock())
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
        
        viewModel.onDataUpdated?(viewModel.selectedActivityTags, viewModel.selectedPeopleTags, viewModel.selectedLocationTags)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func setupNavigationBar() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UITheme.Icons.Navigation.back, for: .normal)
        backButton.tintColor = UITheme.Colors.appWhite
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem

        titleLabel.text = viewModel.title
        titleLabel.font = viewModel.titleFont
        titleLabel.textColor = viewModel.titleColor

        navigationItem.titleView = titleLabel
    }

    private func setupUI() {
        [activityLabel, peopleLabel, locationLabel].forEach {
            $0.font = viewModel.labelsFont
            $0.textColor = viewModel.labelsColor
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        activityLabel.text = viewModel.activityLabel
        peopleLabel.text = viewModel.peopleLabel
        locationLabel.text = viewModel.locationLabel

        saveButton.setTitle(viewModel.saveButtonText, for: .normal)
        saveButton.backgroundColor = viewModel.saveButtonColor
        saveButton.setTitleColor(viewModel.saveButtonTextColor, for: .normal)
        saveButton.titleLabel?.font = viewModel.saveButtonFont
        saveButton.layer.cornerRadius = viewModel.saveButtonCornerRadius
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)

        [emotionCardView, activityLabel, tagSectionActivity, peopleLabel, tagSectionPeople, locationLabel, tagSectionLocation, saveButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emotionCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            emotionCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emotionCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            activityLabel.topAnchor.constraint(equalTo: emotionCardView.bottomAnchor, constant: 24),
            activityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            tagSectionActivity.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 8),
            tagSectionActivity.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagSectionActivity.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            peopleLabel.topAnchor.constraint(equalTo: tagSectionActivity.bottomAnchor, constant: 16),
            peopleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            tagSectionPeople.topAnchor.constraint(equalTo: peopleLabel.bottomAnchor, constant: 8),
            tagSectionPeople.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagSectionPeople.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            locationLabel.topAnchor.constraint(equalTo: tagSectionPeople.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            tagSectionLocation.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            tagSectionLocation.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tagSectionLocation.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 56),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }

    private func setupBindings() {
        viewModel.onDataUpdated = { [weak self] activityTags, peopleTags, locationTags in
            self?.tagSectionActivity.setTags(activityTags)
            self?.tagSectionPeople.setTags(peopleTags)
            self?.tagSectionLocation.setTags(locationTags)
        }
    }

    @objc private func backTapped() {
        viewModel.handle(.dismiss)
    }

    @objc private func saveTapped() {
        viewModel.handle(.saveNote)
    }

    func cleanUp() {
        viewModel.coordinator?.coordinatorDidFinish()
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
