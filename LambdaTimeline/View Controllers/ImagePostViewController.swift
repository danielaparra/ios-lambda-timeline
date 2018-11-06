//
//  ImagePostViewController.swift
//  LambdaTimeline
//
//  Created by Spencer Curtis on 10/12/18.
//  Copyright © 2018 Lambda School. All rights reserved.
//

import UIKit
import Photos

class ImagePostViewController: ShiftableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setImageViewHeight(with: 1.0)
        
        updateViews()
    }
    
    func updateViews() {
        
        guard let imageData = imageData,
            let image = UIImage(data: imageData) else {
                title = "New Post"
                return
        }
        
        title = post?.title
        
        setImageViewHeight(with: image.ratio)
        
        imageView.image = image
        
        chooseImageButton.setTitle("", for: [])
    }
    
    private func presentImagePickerController() {
        
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            presentInformationalAlertController(title: "Error", message: "The photo library is unavailable")
            return
        }
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = .photoLibrary

        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func createPost(_ sender: Any) {
        
        view.endEditing(true)
        
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.1),
            let title = titleTextField.text, title != "" else {
            presentInformationalAlertController(title: "Uh-oh", message: "Make sure that you add a photo and a caption before posting.")
            return
        }
        
        postController.createPost(with: title, ofType: .image, mediaData: imageData, ratio: imageView.image?.ratio) { (success) in
            guard success else {
                DispatchQueue.main.async {
                    self.presentInformationalAlertController(title: "Error", message: "Unable to create post. Try again.")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let authorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch authorizationStatus {
        case .authorized:
            presentImagePickerController()
        case .notDetermined:
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                guard status == .authorized else {
                    NSLog("User did not authorize access to the photo library")
                    self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
                    return
                }
                
                self.presentImagePickerController()
            }
            
        case .denied:
            self.presentInformationalAlertController(title: "Error", message: "In order to access the photo library, you must allow this application access to it.")
        case .restricted:
            self.presentInformationalAlertController(title: "Error", message: "Unable to access the photo library. Your device's restrictions do not allow access.")
            
        }
        presentImagePickerController()
    }
    
    func setImageViewHeight(with aspectRatio: CGFloat) {
        
        imageHeightConstraint.constant = imageView.frame.size.width * aspectRatio
        
        view.layoutSubviews()
    }
    
    @IBAction func selectBlur(_ sender: Any) {
        gaussianBlurLabel.isHidden = false
        gaussianBlurSlider.isHidden = false
        
        exposureLabel.isHidden = true
        exposureSlider.isHidden = true
        vibranceLabel.isHidden = true
        vibranceSlider.isHidden = true
        tintLabel.isHidden = true
        tintSlider.isHidden = true
        temperatureLabel.isHidden = true
        temperatureSlider.isHidden = true
        posterizeLabel.isHidden = true
        posterizeSlider.isHidden = true
    }
    
    @IBAction func selectExposure(_ sender: Any) {
        gaussianBlurLabel.isHidden = true
        gaussianBlurSlider.isHidden = true
        
        exposureLabel.isHidden = false
        exposureSlider.isHidden = false
        vibranceLabel.isHidden = true
        vibranceSlider.isHidden = true
        tintLabel.isHidden = true
        tintSlider.isHidden = true
        temperatureLabel.isHidden = true
        temperatureSlider.isHidden = true
        posterizeLabel.isHidden = true
        posterizeSlider.isHidden = true
    }
    
    @IBAction func selectTintAndTemp(_ sender: Any) {
        gaussianBlurLabel.isHidden = true
        gaussianBlurSlider.isHidden = true
        
        exposureLabel.isHidden = true
        exposureSlider.isHidden = true
        vibranceLabel.isHidden = true
        vibranceSlider.isHidden = true
        tintLabel.isHidden = false
        tintSlider.isHidden = false
        temperatureLabel.isHidden = false
        temperatureSlider.isHidden = false
        posterizeLabel.isHidden = true
        posterizeSlider.isHidden = true
    }
    
    @IBAction func selectVibrance(_ sender: Any) {
        gaussianBlurLabel.isHidden = true
        gaussianBlurSlider.isHidden = true
        
        exposureLabel.isHidden = true
        exposureSlider.isHidden = true
        vibranceLabel.isHidden = false
        vibranceSlider.isHidden = false
        tintLabel.isHidden = true
        tintSlider.isHidden = true
        temperatureLabel.isHidden = true
        temperatureSlider.isHidden = true
        posterizeLabel.isHidden = true
        posterizeSlider.isHidden = true
        
    }
    
    @IBAction func selectPosterize(_ sender: Any) {
        gaussianBlurLabel.isHidden = true
        gaussianBlurSlider.isHidden = true
        
        exposureLabel.isHidden = true
        exposureSlider.isHidden = true
        vibranceLabel.isHidden = true
        vibranceSlider.isHidden = true
        tintLabel.isHidden = true
        tintSlider.isHidden = true
        temperatureLabel.isHidden = true
        temperatureSlider.isHidden = true
        posterizeLabel.isHidden = false
        posterizeSlider.isHidden = false
    }
    
    @IBAction func changeBlur(_ sender: Any) {
    }
    
    @IBAction func changeExposure(_ sender: Any) {
    }
    
    @IBAction func changeTemperature(_ sender: Any) {
    }
    
    @IBAction func changeTint(_ sender: Any) {
    }
    
    @IBAction func changeVibrance(_ sender: Any) {
    }
    
    @IBAction func changePosterize(_ sender: Any) {
    }
    
    private func updateImage() {
        
        guard let imageData = imageData else { return }
        
        
    }
    
    var postController: PostController!
    var post: Post?
    var imageData: Data?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var chooseImageButton: UIButton!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var gaussianBlurLabel: UISlider!
    @IBOutlet weak var gaussianBlurSlider: UISlider!
    @IBOutlet weak var exposureLabel: UILabel!
    @IBOutlet weak var exposureSlider: UISlider!
    @IBOutlet weak var vibranceLabel: UILabel!
    @IBOutlet weak var vibranceSlider: UISlider!
    @IBOutlet weak var tintLabel: UILabel!
    @IBOutlet weak var tintSlider: UISlider!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureSlider: UISlider!
    @IBOutlet weak var posterizeLabel: UILabel!
    @IBOutlet weak var posterizeSlider: UISlider!
    
}

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        chooseImageButton.setTitle("", for: [])
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        
        imageView.image = image
        
        setImageViewHeight(with: image.ratio)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
