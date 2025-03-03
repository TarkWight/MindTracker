//
//  StatisticsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 23.02.2025.
//


import UIKit

final class StatisticsViewController: UIViewController {
    let viewModel: StatisticsViewModel

    private var emotionsChartView: EmotionsOverviewView?

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

        viewModel.onDataUpdated = { [weak self] emotionsData, totalRecords in
            self?.updateUI(with: emotionsData, totalRecords: totalRecords)
        }

        viewModel.handle(.loadData)
    }

    private func updateUI(with emotionsData: [EmotionCategory: Int], totalRecords: Int) {
        
        if let chartView = emotionsChartView {
            chartView.configure(with: emotionsData)
        } else {
            let newChartView = EmotionsOverviewView(
                title: viewModel.emotionsOverviewTitle,
                recordsCount: totalRecords,
                data: emotionsData
            )
            newChartView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(newChartView)
            emotionsChartView = newChartView

            NSLayoutConstraint.activate([
                newChartView.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
                newChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                newChartView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
            ])
        }
    }

    deinit {
        ConsoleLogger.classDeInitialized()
    }
}
