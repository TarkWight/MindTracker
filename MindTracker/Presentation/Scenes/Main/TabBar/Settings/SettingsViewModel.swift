//
//  SettingsViewModel.swift
//  MindTracker
//
//  Created by Tark Wight on 24.02.2025.
//


import Foundation

final class SettingsViewModel: ViewModel {
     weak var coordinator: SettingsCoordinatorProtocol?

    init(coordinator: SettingsCoordinatorProtocol) {
        self.coordinator = coordinator
    }

    func handle(_ event: Event) {
        switch event {
        case .turnOnFaceID:
            turnOnFaceID()
        case .turnOffFaceID:
            turnOffFaceID()
        }
    }
}

extension SettingsViewModel {
    enum Event {
        case turnOnFaceID
        case turnOffFaceID
    }
    
    private func turnOnFaceID() {
        print("Face ID turned on")
    }
    
    private func turnOffFaceID() {
        print("Face ID turned off")
    }
}
