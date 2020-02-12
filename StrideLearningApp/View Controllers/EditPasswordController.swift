//
//  EditPasswordController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/10/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditPasswordController: UIViewController {
    
    var profileController: ProfileController?
    
    let oldPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Old Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let oldPasswordTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isSecureTextEntry = true
        
        return tv
    }()
    
    let oldPasswordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let newPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "New Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let newPasswordTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isSecureTextEntry = true
        
        return tv
    }()
    
    let newPasswordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let confirmPasswordTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isSecureTextEntry = true
        
        return tv
    }()
    
    let confirmPasswordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        //        view.backgroundColor = .blue
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveData))
        
        navigationItem.title = "Edit Password"
        
        view.addSubview(inputsContainerView)
        fetchUserAndSetupProfile()
        
        
    }
    
    func fetchUserAndSetupProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupEditPassword(user)
                
            }
            
        }, withCancel: nil)
    }
    
    func setupEditPassword(_ user: User) {
        inputsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 165).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
        
        inputsContainerView.addSubview(oldPasswordLabel)
        inputsContainerView.addSubview(oldPasswordTextField)
        inputsContainerView.addSubview(oldPasswordSeparatorView)
        inputsContainerView.addSubview(newPasswordLabel)
        inputsContainerView.addSubview(newPasswordTextField)
        inputsContainerView.addSubview(newPasswordSeparatorView)
        inputsContainerView.addSubview(confirmPasswordLabel)
        inputsContainerView.addSubview(confirmPasswordTextField)
        inputsContainerView.addSubview(confirmPasswordSeparatorView)
        
        let multiplier = 0.56 as CGFloat
        
        //Old Password
        oldPasswordLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        oldPasswordLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        oldPasswordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        oldPasswordTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        oldPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        oldPasswordSeparatorView.topAnchor.constraint(equalTo: oldPasswordLabel.bottomAnchor, constant: 12).isActive = true
        oldPasswordSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        oldPasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        oldPasswordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //New Password
        newPasswordLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        newPasswordLabel.topAnchor.constraint(equalTo: oldPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        newPasswordTextField.leftAnchor.constraint(equalTo:oldPasswordTextField.leftAnchor).isActive = true
        newPasswordTextField.topAnchor.constraint(equalTo: oldPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        newPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
//        newPasswordSeparatorView.leftAnchor.constraint(equalTo: oldPasswordTextField.leftAnchor).isActive = true
        newPasswordSeparatorView.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 12).isActive = true
        newPasswordSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        newPasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        newPasswordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Confirm Password
        confirmPasswordLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        confirmPasswordLabel.topAnchor.constraint(equalTo: newPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        
//        confirmPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        confirmPasswordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
//        confirmPasswordSeparatorView.leftAnchor.constraint(equalTo: oldPasswordTextField.leftAnchor).isActive = true
        confirmPasswordSeparatorView.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 12).isActive = true
        confirmPasswordSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        confirmPasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        confirmPasswordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveData() {
        let password = oldPasswordTextField.text!
        let newPassword = newPasswordTextField.text!
        let confirmPassword = confirmPasswordTextField.text!
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
        
        if newPassword != confirmPassword {
            //alert passwords don't match
            print("Passwords don't match")
            let alert=UIAlertController(title: "Error", message: "Passwords don't match.", preferredStyle: UIAlertController.Style.alert)
            //create a UIAlertAction object for the button
            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                self.newPasswordTextField.text=""
                self.confirmPasswordTextField.text=""
            })
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        else{
            //check if valid
            let validPassword = isValidPassword(password: newPassword)
            
            if (validPassword) {
                print("Valid password")
                user?.reauthenticate(with: credential, completion: { (usr, error) in
                    if let error = error {
                        print(error)
                        let alert=UIAlertController(title: "Error", message: "Old Password Incorrect", preferredStyle: UIAlertController.Style.alert)
                        //create a UIAlertAction object for the button
                        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                            self.oldPasswordTextField.text=""
                            self.newPasswordTextField.text=""
                            self.confirmPasswordTextField.text=""
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                        
                        //error for invalid password here
                    }
                    else{
                        user?.updatePassword(to: newPassword, completion: { (error) in
                            if let error = error {
                                print(error)

                            }
                            else {
                                print("updated password")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
                
            else {
                print("Invalid password")
                let alert=UIAlertController(title: "Error", message: "Invalid password. Password must have at least 6 characters, one letter, and one special character.", preferredStyle: UIAlertController.Style.alert)
                //create a UIAlertAction object for the button
                let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                    //dismiss alert
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: password)
        return result
    }
}
