//
//  AuthViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import Foundation

final class AuthViewModel: ViewModel {
    // MARK: - Properties
    var title: String {
        LocalizedKey.AuthView.title
    }
    var buttonTitle: String {
        LocalizedKey.AuthView.buttonTitle
    }
    private let coordinator: AuthCoordinatorProtocol
    
    init(coordinator: AuthCoordinatorProtocol) {
        self.coordinator = coordinator
    }
    
    func handle(_ event: LoginViewEvent) {
        switch event {
        case .logInTapped:
            logInTapped()
        }
    }
}

private extension AuthViewModel {
    func logInTapped() {
        print("Login tapped -> dismiss auth screens")
        coordinator.dismissAuthScreens()
    }
}

enum LoginViewEvent {
    case logInTapped
}
