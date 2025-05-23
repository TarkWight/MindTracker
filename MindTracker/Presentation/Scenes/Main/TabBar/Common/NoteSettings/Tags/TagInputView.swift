//
//  TagInputView.swift
//  MindTracker
//
//  Created by Tark Wight on 15.05.2025.
//

import UIKit

final class TagInputView: UIView {
    private let iconButton = UIButton(type: .system)
    private let textField = UITextField()
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    private var tapOutsideRecognizer: UITapGestureRecognizer?

    var onTagAdded: ((String) -> Void)?

    private var isInputMode = false {
        didSet {
            animateTransition()
            updateDismissTapGesture()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        updateInitialLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    private func setup() {
        layer.cornerRadius = 18
        backgroundColor = AppColors.appGray
        clipsToBounds = true

        iconButton.setImage(AppIcons.plus?.withRenderingMode(.alwaysTemplate), for: .normal)
        iconButton.tintColor = AppColors.appWhite
        iconButton.addTarget(self, action: #selector(plusTapped), for: .touchUpInside)

        textField.placeholder = LocalizedKey.inputTagsTitle
        textField.textColor = AppColors.appWhite
        textField.font = Typography.bodySmall
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.isHidden = true
        textField.delegate = self

        addSubview(iconButton)
        addSubview(textField)
        iconButton.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false

        widthConstraint = widthAnchor.constraint(equalToConstant: 36)
        heightConstraint = heightAnchor.constraint(equalToConstant: 36)

        var constraints: [NSLayoutConstraint] = []

        if let widthConstraint = widthConstraint,
           let heightConstraint = heightConstraint {
            constraints.append(contentsOf: [
                widthConstraint,
                heightConstraint
            ])
        }

        constraints.append(contentsOf: [
            iconButton.widthAnchor.constraint(equalToConstant: 20),
            iconButton.heightAnchor.constraint(equalToConstant: 20),
            iconButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconButton.centerYAnchor.constraint(equalTo: centerYAnchor),

            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate(constraints)
    }

    private func updateInitialLayout() {
        textField.isHidden = true
        iconButton.isHidden = false
    }

    @objc private func plusTapped() {
        isInputMode = true
    }

    func dismissIfTappedOutside(_ locationInSuperview: CGPoint) {
        let localPoint = convert(locationInSuperview, from: superview)

        if isInputMode && !bounds.contains(localPoint) {
            isInputMode = false
        }
    }

    private func animateTransition() {
        UIView.animate(withDuration: 0.25) {
            if self.isInputMode {
                let placeholder = self.textField.placeholder ?? ""
                let font = self.textField.font ?? UIFont.systemFont(ofSize: 16)
                let width = (placeholder as NSString).size(withAttributes: [.font: font]).width + 32
                self.widthConstraint?.constant = max(width, 100)
                self.heightConstraint?.constant = 44
                self.iconButton.isHidden = true
                self.textField.isHidden = false
                self.textField.becomeFirstResponder()
            } else {
                self.widthConstraint?.constant = 36
                self.heightConstraint?.constant = 36
                self.textField.isHidden = true
                self.iconButton.isHidden = false
                self.textField.resignFirstResponder()
            }
            self.superview?.layoutIfNeeded()
        }
    }

    private func updateDismissTapGesture() {
        guard let window = window else { return }

        if isInputMode {
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside(_:)))
            tap.cancelsTouchesInView = false
            window.addGestureRecognizer(tap)
            tapOutsideRecognizer = tap
        } else if let tap = tapOutsideRecognizer {
            window.removeGestureRecognizer(tap)
            tapOutsideRecognizer = nil
        }
    }

    @objc private func handleTapOutside(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self)
        if !bounds.contains(location) {
            isInputMode = false
        }
    }
}

// MARK: - UITextFieldDelegate

extension TagInputView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text?.trimmingCharacters(in: .whitespaces), !text.isEmpty else {
            return false
        }
        onTagAdded?(text)
        textField.text = nil
        isInputMode = false
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard isInputMode else { return }

        let text = textField.text ?? ""
        let font = textField.font ?? UIFont.systemFont(ofSize: 16)
        let width = (text as NSString).size(withAttributes: [.font: font]).width + 32
        widthConstraint?.constant = max(width, 100)
        layoutIfNeeded()
    }
}
