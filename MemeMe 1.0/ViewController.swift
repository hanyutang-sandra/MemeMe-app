//
//  ViewController.swift
//  MemeMe 1.0
//
//  Created by Hanyu Tang on 10/25/21.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    private let memeImageView = UIImageView()
    private let memeImage:UIImage? = nil
    
    private let topTextField = UITextField()
    private let bottomTextField = UITextField()
    
    private let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    private let topToolbar = UIToolbar()
    private let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
    private let cancelBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    
    private let bottomToolbar = UIToolbar()
    private let imagePickBarButtonItem = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(handleImagePick))
    private let cameraBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCameraOpen))
    
    private let flexibleSpaceBarItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memeImage: UIImage
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(memeImageView)
        topTextField.delegate = self
        view.addSubview(topTextField)
        bottomTextField.delegate = self
        view.addSubview(bottomTextField)
        view.addSubview(bottomToolbar)
        view.addSubview(topToolbar)
        installConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraBarButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func installConstraints(){
        view.backgroundColor = .systemGray
        
        configureMemeImageView()
        configureTopTextField()
        configureBottomTextField()
        configureBottomToolbar()
        configureTopToolbar()
    }
}

// MARK: MemeImageView
extension ViewController {
    func configureMemeImageView(){
        memeImageView.translatesAutoresizingMaskIntoConstraints = false
        memeImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            memeImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            memeImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            memeImageView.topAnchor.constraint(equalTo: view.topAnchor),
            memeImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: MemeTextFields
extension ViewController: UITextFieldDelegate {
    func configureTopTextField(){
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        topTextField.autocapitalizationType = .allCharacters
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            topTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func configureBottomTextField(){
        bottomTextField.text = "Bottom"
        bottomTextField.textAlignment = .center
        bottomTextField.autocapitalizationType = .allCharacters
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            bottomTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Keyboard handling
extension ViewController {
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notificationn:Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: BottomToolbar
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func configureBottomToolbar(){
        bottomToolbar.setItems([flexibleSpaceBarItem, imagePickBarButtonItem, cameraBarButtonItem, flexibleSpaceBarItem], animated: true)
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func handleImagePick() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    @objc func handleCameraOpen(){
        let pickerConrtoller = UIImagePickerController()
        pickerConrtoller.delegate = self
        pickerConrtoller.sourceType = .camera
        present(pickerConrtoller, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            memeImageView.image = selectedImage
            shareBarButtonItem.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: TopToolBar
extension ViewController {
    func configureTopToolbar(){
        topToolbar.setItems([shareBarButtonItem, flexibleSpaceBarItem, cancelBarButtonItem], animated: true)
        shareBarButtonItem.isEnabled = false
        topToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topToolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topToolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topToolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc func handleCancel(){
        memeImageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareBarButtonItem.isEnabled = false
    }
    
    func generateMemedImage() -> UIImage {
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        return memedImage
    }
    
    func save() {
        _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memeImage: memeImage!)
    }
    
    @objc func handleShare(){
        let newMemeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [newMemeImage], applicationActivities: nil)
        present(activityViewController, animated: true) {}
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success && error == nil){
                self.save()
                self.dismiss(animated: true, completion: nil);
            }}
    }
}
