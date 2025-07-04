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

    // MARK: - UI Elements

    let titleLabel = UILabel()
    let loginButton = CustomButton()

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
        view.accessibilityIdentifier = AuthAccessibility.containerView

        viewModel.handle = { [weak self] event in
            switch event {
            case .logInTapped:
                self?.loginTapped()
            case .showWebView(let completion):
                let vc = AppleSignInWebViewController(onComplete: completion)
                vc.modalPresentationStyle = .formSheet
                self?.present(vc, animated: true)
            }
        }

        let gradientView = RotatingGradientView(frame: view.bounds)
        gradientView.center = view.center
        view.insertSubview(gradientView, at: 0)

        setupUI()
    }

    // MARK: - Setup UI

    func setupUI() {

        view.backgroundColor = AppColors.appWhite

        for item in [titleLabel, loginButton] {
            view.addSubview(item)
            item.translatesAutoresizingMaskIntoConstraints = false
        }

        titleLabel.text = viewModel.title
        titleLabel.font = Typography.title
        titleLabel.numberOfLines = 2
        titleLabel.accessibilityIdentifier = AuthAccessibility.titleLabel

        setupButtonConfig()
        loginButton.addTarget(
            self,
            action: #selector(loginTapped),
            for: .touchUpInside
        )

        setupConstraints()
    }

    func setupButtonConfig() {

        loginButton.configure(
            with: ButtonConfiguration(
                title: viewModel.buttonTitle,
                textColor: AppColors.appBlack,
                font: Typography.body,
                fontSize: 16,
                icon: AppIcons.authApple,
                iconSize: 48,
                backgroundColor: AppColors.appWhite,
                buttonHeight: 80,
                cornerRadius: 40,
                padding: 24,
                iconPosition: .left
            )
        )
        loginButton.accessibilityIdentifier = AuthAccessibility.loginButton
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

            loginButton.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constants.sidePadding
            ),
            loginButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Constants.sidePadding
            ),
            loginButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -Constants.buttonPadding
            ),
        ])
    }

    // MARK: - Actions

    @objc func loginTapped() {
        viewModel.handle(.logInTapped)
    }

    // MARK: - Constants

    enum Constants {
        static let sidePadding: CGFloat = 24
        static let buttonPadding: CGFloat = 24
        static let safeAreaPadding: CGFloat = 24
    }
}

private enum AuthAccessibility {
    static let titleLabel = "auth_title_label"
    static let loginButton = "auth_login_button"
    static let containerView = "auth_container_view"
}
