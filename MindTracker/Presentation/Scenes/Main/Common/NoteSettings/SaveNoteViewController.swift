//
//  SaveNoteViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//

import Combine
import UIKit

final class SaveNoteViewController: UIViewController, DisposableViewController {
    private let viewModel: SaveNoteViewModel
    private var cancellables = Set<AnyCancellable>()

    private let scrollView = UIScrollView()
    private let contentView = UIView()

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
        self.emotionCardView = EmotionCardView(emotion: viewModel.emotion)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        navigationController?.navigationBar.setBackgroundImage(
            UIImage(),
            for: .default
        )
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear

        setupNavigationBar()
        setupUI()
        setupConstraints()
        scrollView.contentInset.bottom = 88
        scrollView.verticalScrollIndicatorInsets.bottom = 88
        setupBindings()
        viewModel.handle(.viewDidLoad)
    }

    private func setupNavigationBar() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(AppIcons.arrowLeft, for: .normal)
        backButton.tintColor = AppColors.appWhite
        backButton.addTarget(
            self,
            action: #selector(backTapped),
            for: .touchUpInside
        )

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            customView: backButton
        )

        titleLabel.text = viewModel.title
        titleLabel.font = Style.titleFont
        titleLabel.textColor = Style.titleColor
        navigationItem.titleView = titleLabel
    }

    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let saveButtonContainer = UIView()
        saveButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        saveButtonContainer.backgroundColor = .clear
        view.addSubview(saveButtonContainer)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButtonContainer.addSubview(saveButton)

        [activityLabel, peopleLabel, locationLabel].forEach {
            $0.font = Style.labelsFont
            $0.textColor = Style.labelsColor
        }

        activityLabel.text = viewModel.activityLabel
        peopleLabel.text = viewModel.peopleLabel
        locationLabel.text = viewModel.locationLabel

        saveButton.setTitle(viewModel.saveButtonText, for: .normal)
        saveButton.backgroundColor = Style.saveButtonBackgroundColor
        saveButton.setTitleColor(Style.saveButtonTextColor, for: .normal)
        saveButton.titleLabel?.font = Style.saveButtonFont
        saveButton.layer.cornerRadius = Style.saveButtonCornerRadius
        saveButton.addTarget(
            self,
            action: #selector(saveTapped),
            for: .touchUpInside
        )

        [
            emotionCardView, activityLabel, tagSectionActivity, peopleLabel,
            tagSectionPeople,
            locationLabel, tagSectionLocation,
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {

        guard let saveButtonContainer = saveButton.superview else {
            assertionFailure("saveButton is not added to any superview")
            return
        }

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            saveButtonContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            saveButtonContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            saveButtonContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            saveButtonContainer.heightAnchor.constraint(equalToConstant: 88),

            saveButton.leadingAnchor.constraint(equalTo: saveButtonContainer.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: saveButtonContainer.trailingAnchor, constant: -24),
            saveButton.bottomAnchor.constraint(equalTo: saveButtonContainer.bottomAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 56),

            emotionCardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            emotionCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emotionCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            activityLabel.topAnchor.constraint(equalTo: emotionCardView.bottomAnchor, constant: 24),
            activityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            tagSectionActivity.topAnchor.constraint(equalTo: activityLabel.bottomAnchor, constant: 8),
            tagSectionActivity.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagSectionActivity.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            peopleLabel.topAnchor.constraint(equalTo: tagSectionActivity.bottomAnchor, constant: 16),
            peopleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            tagSectionPeople.topAnchor.constraint(equalTo: peopleLabel.bottomAnchor, constant: 8),
            tagSectionPeople.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagSectionPeople.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            locationLabel.topAnchor.constraint(equalTo: tagSectionPeople.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            tagSectionLocation.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            tagSectionLocation.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tagSectionLocation.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tagSectionLocation.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])
    }

    private func setupBindings() {
        viewModel.$allTags
            .receive(on: RunLoop.main)
            .sink { [weak self] tags in
                guard let self = self else { return }
                tagSectionActivity.setAvailableTags(
                    tags.activity.map { $0.name }
                )
                tagSectionPeople.setAvailableTags(tags.people.map { $0.name })
                tagSectionLocation.setAvailableTags(
                    tags.location.map { $0.name }
                )
                tagSectionActivity.setTags(viewModel.selectedActivityTags)
                tagSectionPeople.setTags(viewModel.selectedPeopleTags)
                tagSectionLocation.setTags(viewModel.selectedLocationTags)
            }
            .store(in: &cancellables)

        tagSectionActivity.onTagsUpdated = { [weak self] selected in
            self?.viewModel.handle(.updateTags(type: .activity, tags: selected))
        }
        tagSectionPeople.onTagsUpdated = { [weak self] selected in
            self?.viewModel.handle(.updateTags(type: .people, tags: selected))
        }
        tagSectionLocation.onTagsUpdated = { [weak self] selected in
            self?.viewModel.handle(.updateTags(type: .location, tags: selected))
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

extension SaveNoteViewController {

    fileprivate enum Style {
        static let titleFont = Typography.header3alt
        static let titleColor = AppColors.appWhite

        static let labelsFont = Typography.body
        static let labelsColor = AppColors.appWhite

        static let saveButtonFont = Typography.body
        static let saveButtonBackgroundColor = AppColors.appWhite
        static let saveButtonTextColor = UIColor.black
        static let saveButtonCornerRadius: CGFloat = 20
    }
}
