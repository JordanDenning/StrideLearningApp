//
//  EditProfileController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/5/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditProfileController: UIViewController {
    
    var profileController: ProfileController?
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let firstNameTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let firstNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lastNameTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let lastNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "Grade"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let gradeTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let gradeSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let schoolLabel: UILabel = {
        let label = UILabel()
        label.text = "School"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let schoolTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let schoolSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let emailTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let emailSeparatorView: UIView = {
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
        
        //view.backgroundColor = .white
        view.backgroundColor = UIColor(r: 245, g:245, b:245)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveData))
        
        navigationItem.title = "Edit Profile"
        
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
                self.setupEditInfo(user)
                
            }
            
        }, withCancel: nil)
    }
    
    func setupEditInfo(_ user: User) {
        inputsContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
        
        inputsContainerView.addSubview(firstNameLabel)
        inputsContainerView.addSubview(firstNameTextField)
        inputsContainerView.addSubview(firstNameSeparatorView)
        inputsContainerView.addSubview(lastNameLabel)
        inputsContainerView.addSubview(lastNameTextField)
        inputsContainerView.addSubview(lastNameSeparatorView)
        inputsContainerView.addSubview(gradeLabel)
        inputsContainerView.addSubview(gradeTextField)
        inputsContainerView.addSubview(gradeSeparatorView)
        inputsContainerView.addSubview(schoolLabel)
        inputsContainerView.addSubview(schoolTextField)
        inputsContainerView.addSubview(schoolSeparatorView)
        inputsContainerView.addSubview(emailLabel)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        
        firstNameTextField.text = user.name
        lastNameTextField.text = user.name
        emailTextField.text = user.email
        
        let multiplier = 0.70 as CGFloat

        //First Name
        firstNameLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true

        firstNameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        firstNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true

        //First Name Separator
        firstNameSeparatorView.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 12).isActive = true
        firstNameSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        firstNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        firstNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Last Name
        lastNameLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        lastNameTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        lastNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Last Name Separator
        lastNameSeparatorView.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 12).isActive = true
        lastNameSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        lastNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lastNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Grade
        gradeLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        gradeTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        gradeTextField.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        gradeTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Grade Separator
        gradeSeparatorView.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor, constant: 12).isActive = true
        gradeSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        gradeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        gradeSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //School
        schoolLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        schoolLabel.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        schoolTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        schoolTextField.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor, constant: 30).isActive = true
        schoolTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //School Separator
        schoolSeparatorView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 12).isActive = true
        schoolSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        schoolSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        schoolSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Email
        emailLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailLabel.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        emailTextField.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor, constant: 30).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Email Separator
        emailSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: inputsContainerView.rightAnchor, constant: -12).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveData() {
        let firstName = firstNameTextField.text
//        let lastName = firstNameTextField.text
        var email = emailTextField.text
        email = email?.lowercased()
        
        let user = Auth.auth().currentUser
        
        // Prompt the user to re-provide their sign-in credentials
        if email != user?.email {
            //alert to change email please enter password
            let alertController = UIAlertController(title: "Change Email", message: "Please enter your password to change your emal.", preferredStyle: .alert)
            alertController.addTextField { (passwordTextField) in
                passwordTextField.placeholder = "Enter Password"
                passwordTextField.isSecureTextEntry = true
            }
            let okAction=UIAlertAction(title: "Send", style: UIAlertAction.Style.default, handler: {action in
                
                let passwordTextField = alertController.textFields![0]
                
                guard let password = passwordTextField.text else {
                    print("Form is not valid")
                    return
                }
                
                let credential = EmailAuthProvider.credential(withEmail: user?.email ?? "", password: password)
                
                user?.reauthenticate(with: credential, completion: { (usr, error) in
                    if let error = error {
                        print(error)
                        self.handleError(error)
                        return
                    }
                    else{
                        user?.updateEmail(to: email!, completion: { (error) in
                            if let error = error {
                                print(error)
                                self.handleError(error)
                                return
                            }
                            else {
                                user?.sendEmailVerification(completion: { (error) in
                                    if let error = error {
                                        print(error)
                                        self.handleError(error)
                                        return
                                    }
                                    else{
                                        let alert=UIAlertController(title: "Email Updated", message: "A confirmation email has been sent to your address. ", preferredStyle: UIAlertController.Style.alert)
                                        //create a UIAlertAction object for the button
                                        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                                            //dismiss alert
                                        })
                                        alert.addAction(okAction)
                                        self.present(alert, animated: true, completion: nil)
//                                        return
                                    }
                                })
                                let values = [ "name": firstName, "email": email] as [String : AnyObject]
                                
                                guard let uid = Auth.auth().currentUser?.uid else {
                                    return
                                }
                                
                                let ref = Database.database().reference()
                                let usersReference = ref.child("users").child(uid)
                                
                                usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                                    
                                    if let err = err {
                                        print(err)
                                        self.handleError(err)
                                        return
                                    }
                                })
                                self.dismiss(animated: true, completion: nil)
                            }
                        })

                    }
                })
            })
            let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {action in
                //dismiss alert
            })
            
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        else {
            let values = ["name": firstName, "email": email] as [String : AnyObject]
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            
            
            let ref = Database.database().reference()
            let usersReference = ref.child("users").child(uid)
            
            usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                
                if let err = err {
                    print(err)
                    self.handleError(err)
                    return
                }
                
            })
            
            dismiss(animated: true, completion: nil)
        }
    }
}
