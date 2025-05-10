//
//  ReminderPickerViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 06.05.2025.
//

import UIKit

final class ReminderPickerViewController: UIViewController {

    // MARK: - Public Callback

    var onSave: ((Int, Int) -> Void)?

    // MARK: - UI Elements

    private let titleLabel = UILabel()
    private let saveButton = UIButton(type: .system)
    private let pickerGroupContainer = UIView()
    private let hourPicker = UIPickerView()
    private let minutePicker = UIPickerView()
    private let colonLabel = UILabel()
    private let hourLabel = UILabel()
    private let minuteLabel = UILabel()

    // MARK: - Data

    private let hours = (0...23).map { String(format: "%02d", $0) }
    private let minutes = (0...59).map { String(format: "%02d", $0) }

    private var selectedHour: Int = 0
    private var selectedMinute: Int = 0

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = AppColors.appGrayFaded
        view.layer.cornerRadius = Constants.CornerRadius.sheet
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        setupTitleLabel()
        setupPickers()
        setupSaveButton()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let sheet = sheetPresentationController else { return }

        let targetHeight = view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height

        if sheet.detents != [.custom { _ in targetHeight }] {
            sheet.detents = [.custom { _ in targetHeight }]
        }
    }
    // MARK: - Setup

    // TODO: - Добавить LocalizedKey
    private func setupTitleLabel() {
        titleLabel.text = "Напоминание"
        titleLabel.font = Typography.header1
        titleLabel.textColor = AppColors.appWhite
    }

    private func setupPickers() {
        hourPicker.dataSource = self
        hourPicker.delegate = self
        hourPicker.backgroundColor = AppColors.appWhite
        hourPicker.layer.cornerRadius = Constants.CornerRadius.picker

        minutePicker.dataSource = self
        minutePicker.delegate = self
        minutePicker.backgroundColor = AppColors.appWhite
        minutePicker.layer.cornerRadius = Constants.CornerRadius.picker

        colonLabel.text = ":"
        colonLabel.font = Typography.displayMedium1
        colonLabel.textColor = AppColors.appWhite
        colonLabel.textAlignment = .center

        hourLabel.text = "Часы"
        hourLabel.font = Typography.caption
        hourLabel.textColor = AppColors.appWhite
        hourLabel.textAlignment = .left

        minuteLabel.text = "Минуты"
        minuteLabel.font = Typography.caption
        minuteLabel.textColor = AppColors.appWhite
        minuteLabel.textAlignment = .left
    }

    private func setupSaveButton() {
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.backgroundColor = AppColors.appWhite
        saveButton.layer.cornerRadius = Constants.CornerRadius.button
        saveButton.titleLabel?.font = Typography.body
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        [titleLabel, pickerGroupContainer, saveButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        [hourPicker, colonLabel, minutePicker, hourLabel, minuteLabel].forEach {
            pickerGroupContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        // TODO: - Вынести константы в Constants
        /// Пикеры должны быть одинаковых размеров
        /// Граб в белый покрасить (скрыть систсемный, кастом UIView)
        NSLayoutConstraint.activate([
//            view.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -Constants.Padding.topTitle),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.Padding.topTitle),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Padding.side),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Padding.side),
            titleLabel.bottomAnchor.constraint(equalTo: pickerGroupContainer.topAnchor, constant: -Constants.Padding.topPickers),

            pickerGroupContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Padding.side),
            pickerGroupContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Padding.side),
            pickerGroupContainer.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -Constants.Padding.topPickers),

            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Padding.side),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Padding.side),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Padding.side),
            saveButton.heightAnchor.constraint(equalToConstant: Constants.Sizes.saveButtonHeight),

            hourPicker.topAnchor.constraint(equalTo: pickerGroupContainer.topAnchor),
            hourPicker.leadingAnchor.constraint(equalTo: pickerGroupContainer.leadingAnchor),
            hourPicker.widthAnchor.constraint(lessThanOrEqualToConstant: 170),
            hourPicker.heightAnchor.constraint(equalToConstant: Constants.Sizes.pickerHeight),

            colonLabel.centerYAnchor.constraint(equalTo: hourPicker.centerYAnchor),
            colonLabel.leadingAnchor.constraint(equalTo: hourPicker.trailingAnchor, constant: Constants.Padding.betweenPickers),
            colonLabel.widthAnchor.constraint(equalToConstant: Constants.Sizes.colonWidth),

            minutePicker.topAnchor.constraint(equalTo: pickerGroupContainer.topAnchor),
            minutePicker.leadingAnchor.constraint(equalTo: colonLabel.trailingAnchor, constant: Constants.Padding.betweenPickers),
            minutePicker.trailingAnchor.constraint(equalTo: pickerGroupContainer.trailingAnchor),
            minutePicker.widthAnchor.constraint(lessThanOrEqualToConstant: 170),
            minutePicker.heightAnchor.constraint(equalToConstant: Constants.Sizes.pickerHeight),

            hourLabel.topAnchor.constraint(equalTo: hourPicker.bottomAnchor, constant: Constants.Padding.belowPickerLabel),
            hourLabel.centerXAnchor.constraint(equalTo: hourPicker.centerXAnchor),
            hourLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.labelHeight),

            minuteLabel.topAnchor.constraint(equalTo: minutePicker.bottomAnchor, constant: Constants.Padding.belowPickerLabel),
            minuteLabel.centerXAnchor.constraint(equalTo: minutePicker.centerXAnchor),
            minuteLabel.heightAnchor.constraint(equalToConstant: Constants.Sizes.labelHeight),
            minuteLabel.bottomAnchor.constraint(equalTo: pickerGroupContainer.bottomAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func saveTapped() {
        dismiss(animated: true)
        onSave?(selectedHour, selectedMinute)
    }
}

// MARK: - UIPickerView DataSource & Delegate

extension ReminderPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func setInitialTime(from date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: date)
        if let hour = components.hour, let minute = components.minute {
            selectedHour = hour
            selectedMinute = minute
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == hourPicker ? hours.count : minutes.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return Constants.Sizes.pickerHeight
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Typography.displayMedium
        label.textColor = AppColors.appBlack
        label.text = pickerView == hourPicker ? hours[row] : minutes[row]
        return label
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == hourPicker {
            selectedHour = Int(hours[row]) ?? 0
        } else {
            selectedMinute = Int(minutes[row]) ?? 0
        }
    }
}

// MARK: - Presentation

extension ReminderPickerViewController {
    static func present(from viewController: UIViewController, onSave: @escaping (Int, Int) -> Void) {
        let picker = ReminderPickerViewController()
        picker.onSave = onSave
        picker.modalPresentationStyle = .pageSheet

        if let sheet = picker.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = Constants.CornerRadius.sheet
        }

        viewController.present(picker, animated: true)
    }
}

// MARK: - Constants

fileprivate enum Constants {
    enum Padding {
        static let side: CGFloat = 24
        static let topTitle: CGFloat = 52
        static let topPickers: CGFloat = 24
        static let betweenPickers: CGFloat = 24
        static let belowPickerLabel: CGFloat = 8
    }

    enum Sizes {
        static let titleHeight: CGFloat = 44
        static let pickerHeight: CGFloat = 72
        static let colonWidth: CGFloat = 24
        static let labelHeight: CGFloat = 16
        static let saveButtonHeight: CGFloat = 56
    }

    enum CornerRadius {
        static let picker: CGFloat = 8
        static let sheet: CGFloat = 28
        static let button: CGFloat = 28
    }
}
