//  Created by Ben on 23/06/2023.
//  Copyright © 2023 Ben. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UITextFieldDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var navigator: UINavigationBar!
    @IBOutlet weak var tool: UIToolbar!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareBar: UIBarButtonItem!
    @IBOutlet weak var cancelBar: UIBarButtonItem!
    
    let memeTextAtt: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 44)!,
        .strokeWidth: -3.0
    ]
    
    var bottomHeight: CGFloat!
    
    func configure(_ textField: UITextField) {
        textField.defaultTextAttributes = memeTextAtt
        textField.textAlignment = .center
        textField.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(topText)
        configure(bottomText)
        navigator.topItem?.rightBarButtonItem = cancelBar
        navigator.topItem?.leftBarButtonItem = shareBar
        shareBar.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camera.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        topText.delegate = self
        bottomText.delegate = self
    }
    
    @IBAction func userTapShare() {
        let memedImage = generateMemeImage()
        let sentController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        sentController.completionWithItemsHandler = { (_, completed: Bool, _, _) in
            if completed {
                self.save()
                self.dismiss(animated: true)
            }
        }
        
        present(sentController, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = bottomHeight - getKeyboardHeight(notification: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = bottomHeight
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        bottomHeight = self.view.frame.origin.y
        unsubscribeFromKeyboardNotifications()
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func cancel() {
        imageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
        shareBar.isEnabled = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func pickAnImageFrom(_ source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        if source == .camera {
            imagePicker.sourceType = .camera
            self.present(imagePicker, animated: true, completion: nil)
        }
        if source == .photoLibrary {
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        pickAnImageFrom(.camera)
    }
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        pickAnImageFrom(.photoLibrary)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == bottomText {
            self.subscribeToKeyboardNotifications()
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.layer.masksToBounds = true
            imageView.image = image
            shareBar.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func save() {
        let memes = Meme2(topText: topText.text!, bottomText: bottomText.text!, image: imageView.image, memedImage: generateMemeImage())
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.memes.append(memes)
        }
    }
    
    func generateMemeImage() -> UIImage {
        navigator.isHidden = true
        tool.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        navigator.isHidden = false
        tool.isHidden = false
        return memeImage
    }
}
