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

    required init?(coder: NSCoder) {
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
        
        [titleLabel, googleLoginButton]
            .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.text = viewModel.title
        titleLabel.font = UITheme.Font.AuthScene.title
        titleLabel.numberOfLines = 2
        
        googleLoginButton.configure(with: ButtonConfiguration(
            title: viewModel.buttonTitle,
            textColor: UITheme.Colors.appBlack,
            font: UITheme.Font.AuthScene.googleButton,
            fontSize: 16,
            icon: UITheme.Icons.AuthScene.google,
            iconSize: 48,
            backgroundColor: UITheme.Colors.appWhite,
            buttonHeight: 80,
            cornerRadius: 40,
            padding: 24
        ))
        googleLoginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.safeAreaPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),
            
            
            googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            googleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),
            googleLoginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Layout.buttonPadding)
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
        enum Layout {
            static let sidePadding: CGFloat = 24
            static let buttonPadding: CGFloat = 24
            static let safeAreaPadding: CGFloat = 24
        }
    }
}
