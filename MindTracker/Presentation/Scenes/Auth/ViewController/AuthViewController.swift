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
    let loginButton = UIButton()

    
    
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
        setupUI()
    }
}

private extension AuthViewController {
    func setupUI() {
        view.backgroundColor = .magenta
        
        [titleLabel, loginButton]
            .forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.text = viewModel.title
        titleLabel.font = UITheme.Font.AuthScene.title
        titleLabel.numberOfLines = 2
        
        loginButton.setTitle(viewModel.buttonTitle, for: .normal)
        loginButton.backgroundColor = UIColor(named: Constants.Colors.button)
        loginButton.setTitleColor(UIColor(named: Constants.Colors.textColor), for: .normal)
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Layout.safeAreaPadding),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),
            
            
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Layout.sidePadding),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Layout.sidePadding),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Layout.buttonTopOffset)
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
            static let buttonTopOffset: CGFloat = 48
            static let safeAreaPadding: CGFloat = 24
        }
        
        enum Colors {
            static let button = "AppWhite"
            static let textColor = "AppBlack"
        }
    }
    
    
}
