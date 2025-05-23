//
//  SettingsViewController+AvatarPicker.swift
//  MindTracker
//
//  Created by Tark Wight on 24.05.2025.
//

import Foundation
import PhotosUI

// MARK: - Avatar Picker Presentation

extension SettingsViewController {
    func presentAvatarPicker() {
        let alert = UIAlertController(title: LocalizedKey.avatarPickerTitle, message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: LocalizedKey.avatarPickerCamera, style: .default) { [weak self] _ in
            self?.presentCamera()
        })

        alert.addAction(UIAlertAction(title: LocalizedKey.avatarPickerGallery, style: .default) { [weak self] _ in
            self?.presentGallery()
        })

        alert.addAction(UIAlertAction(title: LocalizedKey.avatarPickerDelete, style: .destructive) { [weak self] _ in
            self?.viewModel.handle(.avatarChanged(Data()))
        })

        alert.addAction(UIAlertAction(title: LocalizedKey.avatarPickerCancel, style: .cancel))

        present(alert, animated: true)
    }

    func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        present(picker, animated: true)
    }

    func presentGallery() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        config.filter = .images

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - Avatar Picker Delegates

extension SettingsViewController: PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self) else { return }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let image = image as? UIImage,
                  let data = image.pngData() else { return }

            DispatchQueue.main.async {
                self?.viewModel.handle(.avatarChanged(data))
            }
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage,
              let data = image.pngData() else { return }

        viewModel.handle(.avatarChanged(data))
    }
}
