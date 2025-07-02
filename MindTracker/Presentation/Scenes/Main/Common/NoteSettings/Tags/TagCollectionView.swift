//
//  TagCollectionView.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

final class TagCollectionView: UIView {
    private var availableTags: [String] = []
    private var selectedTags: Set<String> = []

    private let stackView = UIStackView()
    private var tagButtons: [UIButton] = []
    private let tagInputView = TagInputView()
    var onTagsUpdated: (([String]) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
        setupInputButton()
        setupDismissTap()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setupDismissTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGlobalTap(_:)))
        tap.cancelsTouchesInView = false

        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first {
            window.addGestureRecognizer(tap)
        }
    }

    @objc private func handleGlobalTap(_ gesture: UITapGestureRecognizer) {
        let locationInSelf = gesture.location(in: self)

        if !tagInputView.frame.contains(locationInSelf) {
            tagInputView.dismissIfTappedOutside(locationInSelf)
        }
    }

    private func setupInputButton() {
        tagInputView.onTagAdded = { [weak self] tag in
            guard let self = self else { return }
            self.availableTags.append(tag)
            self.selectedTags.insert(tag)
            self.setAvailableTags(self.availableTags)
            self.onTagsUpdated?(self.getSelectedTags())
        }
        stackView.addArrangedSubview(tagInputView)
    }

    func setAvailableTags(_ tags: [String]) {
        availableTags = Array(Set(tags)).sorted()
        updateTagsUI()
    }

    func setTags(_ tags: [String]) {
        selectedTags = Set(tags)
        updateTagsUI()
    }

    func getSelectedTags() -> [String] {
        Array(selectedTags)
    }

    private func updateTagsUI() {
        for view in stackView.arrangedSubviews where !(view is TagInputView) {
            stackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        var currentRow = UIStackView()
        configureRow(currentRow)
        stackView.insertArrangedSubview(currentRow, at: 0)

        var totalWidth: CGFloat = 0
        let maxWidth = bounds.width > 0 ? bounds.width : UIScreen.main.bounds.width - 32

        for tag in availableTags {
            let button = makeTagButton(title: tag)
            let size = button.intrinsicContentSize

            if totalWidth + size.width + 4 > maxWidth {
                currentRow = UIStackView()
                configureRow(currentRow)
                stackView.insertArrangedSubview(currentRow, at: stackView.arrangedSubviews.count - 1)
                totalWidth = 0
            }

            currentRow.addArrangedSubview(button)
            totalWidth += size.width + 4
        }
    }

    private func configureRow(_ row: UIStackView) {
        row.axis = .horizontal
        row.spacing = 4
        row.alignment = .leading
    }

    private func makeTagButton(title: String) -> UIButton {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = selectedTags.contains(title) ? AppColors.appGrayLight : AppColors.appGray
        config.baseForegroundColor = AppColors.appWhite
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

        let button = UIButton(configuration: config, primaryAction: nil)
        button.titleLabel?.font = Typography.bodySmall
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.translatesAutoresizingMaskIntoConstraints = false

        button.heightAnchor.constraint(equalToConstant: 32).isActive = true

        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if selectedTags.contains(title) {
                selectedTags.remove(title)
            } else {
                selectedTags.insert(title)
            }
                setAvailableTags(availableTags)
            onTagsUpdated?(getSelectedTags())
        }, for: .touchUpInside)

        return button
    }
}
