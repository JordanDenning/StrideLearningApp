//
//  File.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 1/20/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var messagesController: MessagesController?
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 238, g: 238, b: 239)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.setTitle("Login", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        //button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.setTitle("Forgot Password", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 16, g: 153, b: 255), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        button.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    @objc func handleForgotPassword() {
        
        let alertController = UIAlertController(title: "Reset Password", message: "", preferredStyle: .alert)
            alertController.addTextField { (forgotPasswordTextField) in
                forgotPasswordTextField.placeholder = "Enter Email"
            }
            let okAction=UIAlertAction(title: "Send", style: UIAlertAction.Style.default, handler: {action in
                
                let forgotPasswordTextField = alertController.textFields![0]
                
                guard let email = forgotPasswordTextField.text else {
                    print("Form is not valid")
                    return
                }
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error != nil
                   {
                        // Error - Unidentified Email
                        print("Email does not exist")
                        let alert=UIAlertController(title: "Error", message: "Email does not exist.", preferredStyle: UIAlertController.Style.alert)
                        //create a UIAlertAction object for the button
                        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                            //dismiss alert
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                   }
                    else
                   {
                        // Success - Sent recovery email
                        print("Email sent!")
                        let alert=UIAlertController(title: "Email sent.", message: "Please check your email for a password reset link.", preferredStyle: UIAlertController.Style.alert)
                        //create a UIAlertAction object for the button
                        let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                            //dismiss alert
                        })
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        return
                   }

                }
            })
            let cancelAction=UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {action in
                //dismiss alert
            })

            alertController.addAction(okAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        

    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                print(error)
                let alert=UIAlertController(title: "Error", message: "Sorry, you entered an incorrect email address or password.", preferredStyle: UIAlertController.Style.alert)
                //create a UIAlertAction object for the button
                let okAction=UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                    //dismiss alert
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if let user = Auth.auth().currentUser {
                if !user.isEmailVerified {
                    let alertVC = UIAlertController(title: "Verify Email", message: "You must verify your email before logging in. Would you like us to resend another email confirmation link?", preferredStyle: UIAlertController.Style.alert)
                    
                    let resendAction = UIAlertAction(title: "Resend", style: UIAlertAction.Style.default) {(_) in user.sendEmailVerification()
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil)
                    
                    alertVC.addAction(resendAction)
                    alertVC.addAction(cancelAction)
                    self.present(alertVC, animated: true, completion: nil)
                    return
                }
                else {
                    self.messagesController?.fetchUserAndSetupNavBarTitle()

                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        })
        
    }

    let firstNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "First name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let firstNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let lastNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Last name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let lastNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordConfirmTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Confirm Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Stride_Blue")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .gray
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControl.State())
        
        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        // change height of firstNameTextField
        firstNameTextFieldHeightAnchor?.isActive = false
        firstNameTextFieldHeightAnchor = firstNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/5)
        firstNameTextFieldHeightAnchor?.isActive = true
        firstNameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        // change height of lastNameTextField
        lastNameTextFieldHeightAnchor?.isActive = false
        lastNameTextFieldHeightAnchor = lastNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/5)
        lastNameTextFieldHeightAnchor?.isActive = true
        lastNameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        // change height of emailTextField
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/5)
        emailTextFieldHeightAnchor?.isActive = true
        
        // change height of passwordTextField
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/5)
        passwordTextFieldHeightAnchor?.isActive = true
        
        // change height of passwordConfirmTextField
        passwordConfirmTextFieldHeightAnchor?.isActive = false
        passwordConfirmTextFieldHeightAnchor = passwordConfirmTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/5)
        passwordConfirmTextFieldHeightAnchor?.isActive = true
        passwordConfirmTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        hideForgotPasswordButton()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(forgotPasswordButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupForgotPasswordButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()

    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var firstNameTextFieldHeightAnchor: NSLayoutConstraint?
    var lastNameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordConfirmTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //profileImageView.topAnchor.constraint(equalTo:
            //view.topAnchor, constant: 80).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -50).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(firstNameTextField)
        inputsContainerView.addSubview(firstNameSeparatorView)
        inputsContainerView.addSubview(lastNameTextField)
        inputsContainerView.addSubview(lastNameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        inputsContainerView.addSubview(passwordSeparatorView)
        inputsContainerView.addSubview(passwordConfirmTextField)
        
        //firstNameTextField
        //need x, y, width, height constraints
        firstNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        firstNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        firstNameTextFieldHeightAnchor = firstNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        firstNameTextFieldHeightAnchor?.isActive = true
        
        //firstNameSeparatorView
        //need x, y, width, height constraints
        firstNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        firstNameSeparatorView.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor).isActive = true
        firstNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        firstNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //lastNameTextField
        //need x, y, width, height constraints
        lastNameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor).isActive = true
        
        lastNameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        lastNameTextFieldHeightAnchor = lastNameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        lastNameTextFieldHeightAnchor?.isActive = true
        
        //lastNameSeparatorView
        //need x, y, width, height constraints
        lastNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        lastNameSeparatorView.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor).isActive = true
        lastNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        lastNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        //emailTextField
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        
        emailTextFieldHeightAnchor?.isActive = true
        
        //emailSeparatorView
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //passwordTextField
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
        
        //passwordSeparatorView
        //need x, y, width, height constraints
        passwordSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        passwordSeparatorView.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        passwordSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //passwordConfirmTextField
        //need x, y, width, height constraints
        passwordConfirmTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordConfirmTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor).isActive = true
        
        passwordConfirmTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordConfirmTextFieldHeightAnchor = passwordConfirmTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        passwordConfirmTextFieldHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupForgotPasswordButton() {
        //need x, y, width, height constraints
        forgotPasswordButton.isHidden = false
        forgotPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        forgotPasswordButton.topAnchor.constraint(equalTo: loginRegisterButton.bottomAnchor, constant: 12).isActive = true
        forgotPasswordButton.widthAnchor.constraint(equalTo: loginRegisterButton.widthAnchor).isActive = true
        forgotPasswordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func hideForgotPasswordButton() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 1 {
            forgotPasswordButton.isHidden = true
        }
        
        else {
            forgotPasswordButton.isHidden = false
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
}








