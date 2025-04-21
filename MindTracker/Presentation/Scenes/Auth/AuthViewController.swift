//
//  AuthViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

final class AuthViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: AuthViewModel

    let titleLabel = UILabel()
    let googleLoginButton = CustomButton()

    // MARK: - Initializers

    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientView = RotatingGradientView(frame: view.bounds)
        //        let gradientView = RotatingGradientView(frame: CGRect(x: 0, y: 0, width: 920, height: 920))
        gradientView.center = view.center
        //        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.insertSubview(gradientView, at: 0)
        setupUI()
    }
}

private extension AuthViewController {
    func setupUI() {
        view.backgroundColor = .white

        for item in [titleLabel, googleLoginButton] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        titleLabel.text = viewModel.title
        titleLabel.font = UITheme.Font.authSceneTitle
        titleLabel.numberOfLines = 2

        googleLoginButton.configure(with: ButtonConfiguration(
            title: viewModel.buttonTitle,
            textColor: AppColors.appBlack,
            font: UITheme.Font.authSceneAppleButton,
            fontSize: 16,
            icon: UITheme.Icons.AuthScene.google,
            iconSize: 48,
            backgroundColor: AppColors.appWhite,
            buttonHeight: 80,
            cornerRadius: 40,
            padding: 24,
            iconPosition: .left
        ))
        googleLoginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constants.safeAreaPadding
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.sidePadding
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.sidePadding
            ),

            googleLoginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.sidePadding
            ),
            googleLoginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.sidePadding
            ),
            googleLoginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.buttonPadding
            ),
        ])
    }
}

private extension AuthViewController {
    // MARK: - Actions

    @objc func loginTapped() {
        viewModel.handle(.logInTapped)
    }
}

private extension AuthViewController {
    // MARK: - Constants

    enum Constants {
        static let sidePadding: CGFloat = 24
        static let buttonPadding: CGFloat = 24
        static let safeAreaPadding: CGFloat = 24
    }
}
