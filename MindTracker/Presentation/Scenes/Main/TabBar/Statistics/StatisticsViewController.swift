//
//  StatisticsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//


import UIKit

final class StatisticsViewController: UIViewController {
    let viewModel: StatisticsViewModel

//    private let titleLabel = UILabel()
    private let emotionsOverviewLabel = UILabel()
    private let emotionsByDaysLabel = UILabel()
    private let frequentEmotionsLabel = UILabel()
    private let moodOverTimeLabel = UILabel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("Use init(viewModel:) instead")
    }

    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundColor

//        setupNavigationBar()
        setupUI()
        setupConstraints()
    }

//    private func setupNavigationBar() {
//        titleLabel.text = viewModel.screenTitle
//        titleLabel.font = viewModel.titleFont
//        titleLabel.textColor = viewModel.titleColor
//
//        navigationItem.titleView = titleLabel
//    }

    private func setupUI() {
        let labels = [
            emotionsOverviewLabel,
            emotionsByDaysLabel,
            frequentEmotionsLabel,
            moodOverTimeLabel
        ]

        labels.forEach {
            $0.font = viewModel.sectionFont
            $0.textColor = viewModel.sectionTextColor
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        emotionsOverviewLabel.text = viewModel.emotionsOverviewTitle
        emotionsByDaysLabel.text = viewModel.emotionsByDaysTitle
        frequentEmotionsLabel.text = viewModel.frequentEmotionsTitle
        moodOverTimeLabel.text = viewModel.moodOverTimeTitle
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            emotionsOverviewLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            emotionsOverviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            emotionsByDaysLabel.topAnchor.constraint(equalTo: emotionsOverviewLabel.bottomAnchor, constant: 24),
            emotionsByDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            frequentEmotionsLabel.topAnchor.constraint(equalTo: emotionsByDaysLabel.bottomAnchor, constant: 24),
            frequentEmotionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            moodOverTimeLabel.topAnchor.constraint(equalTo: frequentEmotionsLabel.bottomAnchor, constant: 24),
            moodOverTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
