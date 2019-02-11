//
//  ViewController.swift
//  MemeMe
//
//  Created by Ranieri Aguiar on 23/01/19.
//  Copyright © 2019 Ranieri. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var topLabel: UITextField!
    @IBOutlet var bottomLabel: UITextField!
    @IBOutlet var btnCamera: UIBarButtonItem!
    @IBOutlet var navBar: UINavigationBar!
    
    var leftBarButtonItem: UIBarButtonItem!
    var isEditingBottonLabel = false
    
    let topText = "TOP"
    let bottomText = "BOTTOM"
    
    // MARK: viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCamera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        let memeTextAttributes:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 35)!,
            NSAttributedString.Key.strokeWidth: 3.0]
        topLabel.defaultTextAttributes = memeTextAttributes
        bottomLabel.defaultTextAttributes = memeTextAttributes
        topLabel.textAlignment = .center
        bottomLabel.textAlignment = .center
        topLabel.delegate = self
        bottomLabel.delegate = self
        
        leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(ViewController.btnShareAction))
        let rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: self, action: #selector(ViewController.btnCancelAction))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        navBar.pushItem(navigationItem, animated: false)
        enableShare(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        if bottomLabel.text!.isEmpty {
            bottomLabel.text = bottomText
        }
        if topLabel.text!.isEmpty {
            topLabel.text = topText
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditingBottonLabel = textField == bottomLabel
        if (textField.text?.hasPrefix(topText))! || (textField.text?.hasSuffix(bottomText))! {
            textField.text = ""
        }
    }
    
    func enableShare(_ isEnable: Bool) {
        leftBarButtonItem.isEnabled = isEnable
        if !isEnable {
            topLabel.text = topText
            bottomLabel.text = bottomText
            image.image = UIImage()
        }
    }
    
    // MARK: save
    func save() {
        let memedImage = generateMemedImage()
        _ = Meme(textTop: topLabel.text!, textBottom: bottomLabel.text!, originalImage: image.image!, memedImage: memedImage)
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        controller.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                self.enableShare(false)
                return
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        return memedImage
    }
    
    // MARK: button
    @objc func btnShareAction() {
        save()
    }
    
    @objc func btnCancelAction() {
        enableShare(false)
    }
    
    @IBAction func btnCameraAction(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func btnGalleryAction(_ sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: imagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image.image = selectedImage
            enableShare(true)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: keyboard
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if isEditingBottonLabel {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
