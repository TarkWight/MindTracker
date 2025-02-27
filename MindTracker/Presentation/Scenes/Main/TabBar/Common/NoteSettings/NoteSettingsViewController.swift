//
//  NoteSettingsViewController.swift
//  MindTracker
//
//  Created by Tark Wight on 21.02.2025.
//

import UIKit

class NoteSettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemMint
        addLabel()
    }
    
    // add lable to the view
    private func addLabel() {
        let label = UILabel()
        label.text = "NoteSettingsViewController"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
    }
}
