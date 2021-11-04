//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Hanyu Tang on 10/25/21.
//

import UIKit
import Foundation

class MemeEditorViewController: UIViewController {
    private let memeImageView = UIImageView()
    
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
    private let imagePickBarButtonItem = UIBarButtonItem(title: "Album", style: .plain, target: self, action: #selector(handleLibraryImagePick))
    private let cameraBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(handleCameraOpen))
    
    private let flexibleSpaceBarItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
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
extension MemeEditorViewController {
    func configureMemeImageView(){
        memeImageView.translatesAutoresizingMaskIntoConstraints = false
        memeImageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            memeImageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            memeImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
}

// MARK: MemeTextFields
extension MemeEditorViewController: UITextFieldDelegate {
    func configureTopTextField(){
        setupTextField(textField: topTextField, defaultText: "TOP")
        topTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
    }
    
    func configureBottomTextField(){
        setupTextField(textField: bottomTextField, defaultText: "BOTTOM")
        bottomTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupTextField(textField: UITextField, defaultText: String) {
        textField.text = defaultText
        textField.adjustsFontSizeToFitWidth = true
        textField.autocapitalizationType = .allCharacters
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}

// MARK: Keyboard handling
extension MemeEditorViewController {
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
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: BottomToolbar
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func configureBottomToolbar(){
        bottomToolbar.setItems([flexibleSpaceBarItem, imagePickBarButtonItem, cameraBarButtonItem, flexibleSpaceBarItem], animated: true)
        bottomToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomToolbar.widthAnchor.constraint(equalTo: view.widthAnchor),
            bottomToolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc func handleLibraryImagePick() {
        handleImagePick(source: .photoLibrary)
    }
    
    @objc func handleCameraOpen(){
        handleImagePick(source: .camera)
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
    
    func handleImagePick(source: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
}

// MARK: TopToolBar
extension MemeEditorViewController {
    func configureTopToolbar(){
        topToolbar.setItems([shareBarButtonItem, flexibleSpaceBarItem, cancelBarButtonItem], animated: true)
        shareBarButtonItem.isEnabled = false
        topToolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topToolbar.widthAnchor.constraint(equalTo: view.widthAnchor),
            topToolbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
    
    @objc func handleCancel(){
        memeImageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        shareBarButtonItem.isEnabled = false
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        topToolbar.isHidden = true
        bottomToolbar.isHidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        topToolbar.isHidden = false
        bottomToolbar.isHidden = false
        return memedImage
    }
    
    func save(memeImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: memeImageView.image!, memeImage: memeImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    @objc func handleShare(){
        let newMemeImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [newMemeImage], applicationActivities: nil)
        present(activityViewController, animated: true)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success && error == nil){
                self.save(memeImage: newMemeImage)
                self.dismiss(animated: true, completion: nil);
            }}
    }
}
