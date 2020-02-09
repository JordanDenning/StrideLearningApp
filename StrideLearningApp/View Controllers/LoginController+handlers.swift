//
//  LoginController+handlers.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        //email validation
    func isValidEmail(email: String) -> Bool {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            let result = emailTest.evaluate(with: email)
            return result
        }
        
        var validEmail = isValidEmail(email: emailTextField.text!)
        
        if (validEmail) {
            print("Valid email")
        }
        
        else {
            print("Invalid email")
            let alert=UIAlertController(title: "Error", message: "Invalid email.", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                //dismiss alert
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
            
        }
        
        //password validation
    func isValidPassword(password: String) -> Bool {
            let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}"
            let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
            let result = passwordTest.evaluate(with: password)
            return result
        }
        
        let validPassword = isValidPassword(password: passwordTextField.text!)
        
        if (validPassword) {
            print("Valid password")
        }
        
        else {
            print("Invalid password")
            let alert=UIAlertController(title: "Error", message: "Invalid password. Password must have at least 6 characters, one letter, and one special character.", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                //dismiss alert
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        //check if passwords match
        if self.passwordTextField.text != self.passwordConfirmTextField.text {
            print("Passwords don't match")
            let alert=UIAlertController(title: "Error", message: "Passwords don't match.", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                self.passwordTextField.text=""
                self.passwordConfirmTextField.text=""
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            //error in creating account
            if let error = error {
                print(error)
                let alert=UIAlertController(title: "Error", message: "This email address is already in use by another account.", preferredStyle: UIAlertController.Style.alert)
                //create a UIAlertAction object for the button
                let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                    //dismiss alert
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            guard let uid = user?.user.uid else {
                return
            }
            
            //email address verification
            if let user = Auth.auth().currentUser {
                Auth.auth().currentUser?.sendEmailVerification { (error) in
                    // send email verification
                }
                if !user.isEmailVerified {
                    let alertVC = UIAlertController(title: "Verify Email", message: "A confirmation email has been sent to your address.", preferredStyle: UIAlertController.Style.alert)
                    self.present(alertVC, animated: true, completion: nil)
                    
                    // change to desired number of seconds
//                    let alertTime = DispatchTime.now() + 8
//                    DispatchQueue.main.asyncAfter(deadline: alertTime){
//                      // your code with delay
//                      alertVC.dismiss(animated: true, completion: nil)
//                    }
                }
            }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString //get unique image name to use for uploading and storing
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            //.child("profile_images") creates new child folder where these images will be stored
            
            if let profileImage = UIImage(named: "profile2"), let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                
                storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                    
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    //successfully uploaded image to firebase after above code putData
                    
                    storageRef.downloadURL(completion: { (url, err) in
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        guard let url = url else { return }
                        let values = ["name": name, "email": email, "profileImageUrl": url.absoluteString]
                        
                        self.registerUserIntoDatabaseWithUID(uid, values: values as [String : AnyObject])
                    })
                    
                })
            }
        })
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if let err = err {
                print(err)
                return
            }
            
            let user = User(dictionary: values)
            //this setter potentially crashes if keys don't match
            self.messagesController?.setupNavBarWithUser(user)
            
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
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
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
