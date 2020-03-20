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
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 2
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
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 245, g:245, b:245)
        
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
                
                let user = User(dictionary: dictionary)
                self.setupEditPassword(user)
                
            }
            
        }, withCancel: nil)
    }
    
    func setupEditPassword(_ user: User) {
        inputsContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 165).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        
        inputsContainerView.addSubview(oldPasswordLabel)
        inputsContainerView.addSubview(oldPasswordTextField)
        inputsContainerView.addSubview(oldPasswordSeparatorView)
        inputsContainerView.addSubview(newPasswordLabel)
        inputsContainerView.addSubview(newPasswordTextField)
        inputsContainerView.addSubview(newPasswordSeparatorView)
        inputsContainerView.addSubview(confirmPasswordLabel)
        inputsContainerView.addSubview(confirmPasswordTextField)
        inputsContainerView.addSubview(confirmPasswordSeparatorView)
        
        oldPasswordTextField.font = UIFont.systemFont(ofSize: 14)
        newPasswordTextField.font = UIFont.systemFont(ofSize: 14)
        confirmPasswordTextField.font = UIFont.systemFont(ofSize: 14)
        
        let multiplier = 0.50 as CGFloat
        
        //Old Password
        oldPasswordLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        oldPasswordLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        oldPasswordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        oldPasswordTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        oldPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        oldPasswordSeparatorView.topAnchor.constraint(equalTo: oldPasswordLabel.bottomAnchor, constant: 12).isActive = true
        oldPasswordSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        oldPasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        oldPasswordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //New Password
        newPasswordLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        newPasswordLabel.topAnchor.constraint(equalTo: oldPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        newPasswordTextField.leftAnchor.constraint(equalTo:oldPasswordTextField.leftAnchor).isActive = true
        newPasswordTextField.topAnchor.constraint(equalTo: oldPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        newPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        newPasswordSeparatorView.topAnchor.constraint(equalTo: newPasswordLabel.bottomAnchor, constant: 12).isActive = true
        newPasswordSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        newPasswordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        newPasswordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Confirm Password
        confirmPasswordLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 8).isActive = true
        confirmPasswordLabel.topAnchor.constraint(equalTo: newPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        confirmPasswordTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: newPasswordSeparatorView.bottomAnchor, constant: 30).isActive = true
        confirmPasswordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        confirmPasswordSeparatorView.topAnchor.constraint(equalTo: confirmPasswordLabel.bottomAnchor, constant: 12).isActive = true
        confirmPasswordSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
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

            print("Valid password")
            user?.reauthenticate(with: credential, completion: { (usr, error) in
                if let error = error {
                    print(error)
                    self.handleError(error)
                    return
                }
                else{
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
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    else {
                        let validPassword = self.isValidPassword(password: newPassword)
                        if(!validPassword){
                            let alert=UIAlertController(title: "Error", message: "Invalid password. Password must have at least 6 characters, one letter, and one special character.", preferredStyle: UIAlertController.Style.alert)
                            //create a UIAlertAction object for the button
                            let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                                //dismiss alert
                            })
                            alert.addAction(okAction)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        user?.updatePassword(to: newPassword, completion: { (error) in
                            if let error = error {
                                print(error)
                                self.handleError(error)
                                return
                            }
                            else {
                                print("updated password")
                                //alert successfully updated password
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                }
            })
    }
    
    func isValidPassword(password: String) -> Bool {
        let passwordRegEx = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{6,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        let result = passwordTest.evaluate(with: password)
        return result
    }
}
