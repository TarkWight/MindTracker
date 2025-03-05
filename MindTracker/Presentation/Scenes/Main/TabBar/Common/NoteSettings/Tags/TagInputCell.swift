//
//  TagInputCell.swift
//  MindTracker
//
//  Created by Tark Wight on 02.03.2025.
//

import UIKit

final class TagInputCell: UICollectionViewCell {
    static let identifier = "TagInputCell"

    private let plusButton = UIButton(type: .system)
    private let textField = UITextField()

    var onTagAdded: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 18
        contentView.backgroundColor = UITheme.Colors.appGray
        contentView.clipsToBounds = true

        plusButton.setTitle("+", for: .normal)
        plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        plusButton.setTitleColor(UITheme.Colors.appWhite, for: .normal)
        plusButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        textField.placeholder = "Введите тег"
        textField.textColor = UITheme.Colors.appWhite
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.isHidden = true
        textField.delegate = self

        contentView.addSubview(plusButton)
        contentView.addSubview(textField)

        plusButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            plusButton.widthAnchor.constraint(equalToConstant: 36),
            plusButton.heightAnchor.constraint(equalToConstant: 36),
            plusButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            plusButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            textField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            textField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            textField.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    @objc private func plusTapped() {
        plusButton.isHidden = true
        textField.isHidden = false
        textField.becomeFirstResponder()
    }
}

extension TagInputCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        onTagAdded?(text)
        textField.text = ""
        textField.resignFirstResponder()
        textField.isHidden = true
        plusButton.isHidden = false
        return true
    }
}
