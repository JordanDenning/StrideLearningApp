//
//  ChatLogController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var chatroomId = String()
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    var currentUser: User?
    
    var messages = [Message]()
    

    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid, let toId = user?.id, let fromId = Auth.auth().currentUser?.uid else {
            return
        }
        
        appDelegate.currentChatPageId = toId
        
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                return
            }

            self.currentUser = User(dictionary: dictionary)
            self.currentUser!.id = uid

        }, withCancel: nil)

        chatroomId = (fromId < toId) ? fromId + "_" + toId : toId + "_" + fromId

        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(chatroomId)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in

            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(self.chatroomId).child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in

                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }

                let message = Message(dictionary: dictionary)

                //do we need to attempt filtering anymore?
                self.messages.append(message)
                DispatchQueue.main.async(execute: {
                    self.collectionView?.reloadData()
                    self.scrollToBottom()
                })

            }, withCancel: nil)

        }, withCancel: nil)
    }
    
    
    let cellId = "cellId"
    
    var bottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.keyboardDismissMode = .interactive
        scrollToBottom()
        print("view loaded")
        
        setupKeyboardObservers()
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if (self.messages.count > 0) {
                self.collectionView?.reloadData()
                let lastItemIndex = NSIndexPath(item: self.messages.count - 1, section: 0)
                self.collectionView?.scrollToItem(at: lastItemIndex as IndexPath, at: UICollectionView.ScrollPosition.bottom, animated: true)
            }
        }
    }
    
    lazy var inputTextField: UITextView = {
        let textField = UITextView()
        textField.layer.cornerRadius = 10
        textField.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        textField.layer.borderWidth = 1
        let myColor : UIColor = UIColor(r: 220, g: 220, b: 220)
        textField.layer.borderColor = myColor.cgColor
        textField.text = "Enter message..."
        textField.font = UIFont.systemFont(ofSize: 15.0)
        textField.textColor = UIColor.lightGray
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: textField.contentSize.height))
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isScrollEnabled = false
        textField.delegate = self
        
        return textField
    }()
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if inputTextField.textColor == UIColor.lightGray {
            inputTextField.text = nil
            inputTextField.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if inputTextField.text.isEmpty {
            inputTextField.text = "Enter message..."
            inputTextField.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.adjustTextViewHeight()
        sendButton.isEnabled = !inputTextField.text.isEmpty
    }

    
    var textHeightConstraint: NSLayoutConstraint!
    
    lazy var sendButton: UIButton = {
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: UIControl.State())
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.isEnabled = false
        
        return sendButton
    }()
  
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        containerView.backgroundColor = .white
        
        let uploadImageView = UIImageView()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "upload_image_icon")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        containerView.addSubview(uploadImageView)
        //x,y,w,h
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 26).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //x,y,w,h
        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
        self.inputTextField.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        self.textHeightConstraint = self.inputTextField.heightAnchor.constraint(equalToConstant: 40)
        self.textHeightConstraint.isActive = true
        
        self.adjustTextViewHeight()

        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
        
        return containerView
    }()
    
    @objc func handleUploadTap() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    // Local variable inserted by Swift 4.2 migrator.
    let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

            
    var selectedImageFromPicker: UIImage?
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
        selectedImageFromPicker = editedImage
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
        
        selectedImageFromPicker = originalImage
    }
    
    if let selectedImage = selectedImageFromPicker {
        uploadToFirebaseStorageUsingImage(selectedImage)
    }
    
    dismiss(animated: true, completion: nil)
}
        
        fileprivate func uploadToFirebaseStorageUsingImage(_ image: UIImage) {
            let imageName = UUID().uuidString
            let ref = Storage.storage().reference().child("message_images").child(imageName)
            
            if let uploadData = image.jpegData(compressionQuality: 0.2) {
                ref.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print("Failed to upload image:", error!)
                        return
                    }
                    
                    ref.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        self.sendMessageWithImageUrl(url?.absoluteString ?? "", image: image)
                    })
                    
                })
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }

    func adjustTextViewHeight() {
        
        let fixedWidth = inputTextField.frame.size.width
        let newSize = inputTextField.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if (newSize.height >= 70.0) {
            inputTextField.isScrollEnabled = true
            print("scrolling")
        }
        
        else if (newSize.height < 70.0) {
            inputTextField.isScrollEnabled = false
            self.textHeightConstraint.constant = newSize.height
            print(newSize.height)
            self.view.layoutIfNeeded()
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
            
        }, completion: { (completed) in
            
            //scroll to bottom of messages when keyboard toggled
            let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        
        //lets modify the bubbleView's width somehow???
        if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        } else if let text = message.text {
            //a text message
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text).width + 32
            cell.textView.isHidden = false
        }
        
        return cell
    }
    
    
    fileprivate func setupCell(_ cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        if let seconds = message.timestamp?.doubleValue {
            let timestampDate = Date(timeIntervalSince1970: seconds)
            let date = Date()
            
            let dateFormatter = DateFormatter()
            if Calendar.current.isDateInYesterday(timestampDate) {
                cell.timeLabel.text = "Yesterday"
            } else {
                if Calendar.current.isDateInToday(timestampDate){
                    dateFormatter.dateFormat = "hh:mm a"
                } else if Calendar.current.isDate(timestampDate, equalTo: date, toGranularity: .weekOfYear) {
                    dateFormatter.dateFormat = "EEEE"
                } else {
                    dateFormatter.dateFormat = "M/d/yy"
                }
                
                cell.timeLabel.text = dateFormatter.string(from: timestampDate)
            }
        }

        
        if message.fromId == Auth.auth().currentUser?.uid {
            //outgoing blue
            cell.bubbleView.backgroundColor = UIColor(r: 16, g: 153, b: 255)
            cell.textView.textColor = UIColor.white
            cell.profileImageView.isHidden = true
            
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
            cell.timeLabelRightAnchor?.isActive = true
            cell.timeLabelLeftAnchor?.isActive = false
            
        } else {
            //incoming gray
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.black
            cell.profileImageView.isHidden = false
            
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            
            cell.timeLabelRightAnchor?.isActive = false
            cell.timeLabelLeftAnchor?.isActive = true
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = UIColor.clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        //get estimated height somehow????
        let message = messages[indexPath.item]
        if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            
            // h1 / w1 = h2 / w2
            // solve for h1
            // h1 = h2 / w2 * w1
            
            height = CGFloat(imageHeight / imageWidth * 200)
            
        } else if let text = message.text {
               height = estimateFrameForText(text).height + 30
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    fileprivate func estimateFrameForText(_ text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font): UIFont.systemFont(ofSize: 16)]), context: nil)
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    @objc func handleSend() {
        let properties = ["text": inputTextField.text!]
        sendMessageWithProperties(properties as [String : AnyObject])
    }
    
    fileprivate func sendMessageWithImageUrl(_ imageUrl: String, image: UIImage) {
        let properties: [String: AnyObject] = ["text": "Sent an image" as AnyObject, "imageUrl": imageUrl as AnyObject, "imageWidth": image.size.width as AnyObject, "imageHeight": image.size.height as AnyObject]
        sendMessageWithProperties(properties)
    }
    
    @objc func sendMessageWithProperties(_ properties: [String: AnyObject]) {
        self.textHeightConstraint.constant = 35
        let toId = user!.id!
        let toName = user!.name!
        let fromId = Auth.auth().currentUser!.uid
        let fromName = currentUser!.name!
        let fcmToken = user!.fcmToken!
        let timestamp = Int(Date().timeIntervalSince1970)
        let chatroomId = (fromId < toId) ? fromId + "_" + toId : toId + "_" + fromId
        let ref = Database.database().reference().child("messages").child(chatroomId)
        let childRef = ref.childByAutoId()
        let text = properties["text"] as! String
        
        var values: [String: AnyObject] = ["toId": toId as AnyObject, "toName": toName as AnyObject, "fromId": fromId as AnyObject, "fromName": fromName as AnyObject, "timestamp": timestamp as AnyObject, "chatroomId": chatroomId as AnyObject]

        properties.forEach({values[$0] = $1})
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.inputTextField.text = nil
            self.inputTextField.resignFirstResponder()
            self.sendButton.isEnabled = false
            
            guard let messageId = childRef.key else { return }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(chatroomId)
            userMessagesRef.child(messageId).setValue(1)
            userMessagesRef.child("seeMessages").setValue("yes")
            
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(chatroomId)
            recipientUserMessagesRef.child(messageId).setValue(1)
            recipientUserMessagesRef.child("seeMessages").setValue("yes")
            
        }
        
        //update messages notifications for user
        let refNotify = ref.child(toId)
        refNotify.observeSingleEvent(of: .value, with: { (snapshot) in
            
           if let messages = snapshot.value as? Int {
                let notifications = messages + 1
                refNotify.setValue(notifications)
           } else {
                refNotify.setValue(1)
            }
            
        }, withCancel: nil)
        
        //update users overall notifications
        let ref2 = Database.database().reference().child("users").child(toId)
        let usersRef = ref2.child("notifications")

        usersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let notify = snapshot.value as? Int else {
                return
            }
            let notifications = notify + 1

            usersRef.setValue(notifications)
            let sender = PushNotificationSender()
            sender.sendPushNotification(to: fcmToken, title: fromName, body: text, badge: notifications, chatroomId:  chatroomId)

        }, withCancel: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    //my custom zooming logic
    func performZoomInForStartingImageView(_ startingImageView: UIImageView) {
        
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = UIColor.red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        if let keyWindow = UIApplication.shared.keyWindow {
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = UIColor.black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.blackBackgroundView?.alpha = 1
                self.inputContainerView.alpha = 0
                
                // math?
                // h2 / w1 = h1 / w1
                // h2 = h1 / w1 * w1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                zoomingImageView.center = keyWindow.center
                
                }, completion: { (completed) in
//                    do nothing
            })
            
        }
    }
    
    @objc func handleZoomOut(_ tapGesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGesture.view {
            //need to animate back out to controller
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
                }, completion: { (completed) in
                    zoomOutImageView.removeFromSuperview()
                    self.startingImageView?.isHidden = false
            })
        }
    }
}







// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}
