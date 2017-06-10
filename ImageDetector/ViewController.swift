//
//  ViewController.swift
//  ImageDetector
//
//  Created by Thibault Klein on 6/9/17.
//  Copyright © 2017 Thibault Klein. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = "Pick an image 🏞"
        }
    }

    let model = Resnet50()

    private var image: UIImage? {
        didSet {
            if let image = image {
                applyImage(image: image)
            }
        }
    }

    func applyImage(image: UIImage) {
        imageView.image = image

        guard let imagePixelBuffer = image
            .resize(to: CGSize(width: 224, height: 224))
            .pixelBuffer() else {
            return
        }

        do {
            let text = try objectName(forImage: imagePixelBuffer)
            label.text = text
        } catch {
            label.text = "Could not recognize this image... 😔"
        }
    }

    func objectName(forImage image: CVPixelBuffer) throws -> String {
        let output = try model.prediction(image: image)
        return output.classLabel
    }

    @IBAction func selectImageTapped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        }
    }

}

extension ViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        image = info[UIImagePickerControllerOriginalImage] as? UIImage
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}

extension ViewController: UINavigationControllerDelegate {

}
