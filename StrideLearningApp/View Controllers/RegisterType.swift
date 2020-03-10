//
//  RegisterType.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/7/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class RegisterType: UIViewController {
    
    var email: String?
    var password: String?
    var messagesController: MessagesController?
    var loginController: LoginController?
    var profileController: ProfileController?
    
    lazy var typeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Student", "Mentor"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.backgroundColor = .white
        sc.tintColor = UIColor(r: 16, g: 153, b: 255)
        sc.selectedSegmentIndex = 0
        sc.layer.cornerRadius = 10
        
        // selected option color
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], for: .selected)
        
        // color of other options
        sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        
        sc.addTarget(self, action: #selector(studentMentorChange), for: .valueChanged)
        return sc
    }()
    
    lazy var segmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Are you a student or a mentor?"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var mentorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please enter the correct access code."
        label.numberOfLines = 0
        return label
    }()
    
    let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Code"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let codeTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isSecureTextEntry = true
        
        return tv
    }()
    
    let codeSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var studentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please enter your grade and school"
        label.numberOfLines = 0
        return label
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
    
    
    lazy var registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.setTitle("Login", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        
        return button
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var mentorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var studentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    let multiplier = 0.70 as CGFloat
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(typeSegmentedControl)
        view.addSubview(segmentLabel)
        view.addSubview(containerView)
        view.addSubview(registerButton)
        
        setupContainerView()
        setupTypeSegmentedControlAndLabel()
        setupButton()
        
        mentorView.isHidden = true
    }
    
    func setupTypeSegmentedControlAndLabel() {
        segmentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70).isActive = true
        //need x, y, width, height constraints
        typeSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        typeSegmentedControl.topAnchor.constraint(equalTo: segmentLabel.bottomAnchor, constant: 20).isActive = true
        typeSegmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -36).isActive = true
        typeSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupContainerView(){
        containerView.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 15).isActive = true
        containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: typeSegmentedControl.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        containerView.addSubview(studentView)
        containerView.addSubview(mentorView)
        setupStudentView()
        setupMentorView()
    
    }
    
    func setupStudentView(){
        //studentView
        studentView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        studentView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        studentView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        studentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        studentView.addSubview(studentLabel)
        studentView.addSubview(gradeLabel)
        studentView.addSubview(gradeTextField)
        studentView.addSubview(gradeSeparatorView)
        studentView.addSubview(schoolLabel)
        studentView.addSubview(schoolTextField)
        studentView.addSubview(schoolSeparatorView)
        
        //studentLabel
        studentLabel.topAnchor.constraint(equalTo: studentView.topAnchor, constant: 12).isActive = true
        studentLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Grade
        gradeLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 12).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: studentLabel.bottomAnchor, constant: 15).isActive = true
        
        gradeTextField.rightAnchor.constraint(equalTo: studentView.rightAnchor).isActive = true
        gradeTextField.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        gradeTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Grade Separator
        gradeSeparatorView.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor, constant: 12).isActive = true
        gradeSeparatorView.rightAnchor.constraint(equalTo: studentView.rightAnchor, constant: -12).isActive = true
        gradeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        gradeSeparatorView.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //School
        schoolLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 12).isActive = true
        schoolLabel.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        schoolTextField.rightAnchor.constraint(equalTo: studentView.rightAnchor).isActive = true
        schoolTextField.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor, constant: 30).isActive = true
        schoolTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //School Separator
        schoolSeparatorView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 12).isActive = true
        schoolSeparatorView.rightAnchor.constraint(equalTo: studentView.rightAnchor, constant: -12).isActive = true
        schoolSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        schoolSeparatorView.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
    }
    
    func setupMentorView(){
        //mentorView
        mentorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        mentorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mentorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        mentorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        mentorView.addSubview(mentorLabel)
        mentorView.addSubview(codeLabel)
        mentorView.addSubview(codeTextField)
        mentorView.addSubview(codeSeparatorView)

        
        //mentorLabel
        mentorLabel.topAnchor.constraint(equalTo: mentorView.topAnchor, constant: 12).isActive = true
        mentorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //Code
        codeLabel.leftAnchor.constraint(equalTo: mentorView.leftAnchor, constant: 12).isActive = true
        codeLabel.topAnchor.constraint(equalTo: mentorLabel.bottomAnchor, constant: 15).isActive = true
        
        codeTextField.rightAnchor.constraint(equalTo: mentorView.rightAnchor).isActive = true
        codeTextField.topAnchor.constraint(equalTo: codeLabel.topAnchor).isActive = true
        codeTextField.widthAnchor.constraint(equalTo: mentorView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code Separator
        codeSeparatorView.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor, constant: 12).isActive = true
        codeSeparatorView.rightAnchor.constraint(equalTo: mentorView.rightAnchor, constant: -12).isActive = true
        codeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        codeSeparatorView.widthAnchor.constraint(equalTo: mentorView.widthAnchor, multiplier: multiplier).isActive = true
        
        
    }
    
    func setupButton(){
        registerButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -12).isActive = true
    }
    
    @objc func studentMentorChange(){
        if typeSegmentedControl.selectedSegmentIndex == 0 {
            mentorView.isHidden = true
            studentView.isHidden = false
        } else {
            mentorView.isHidden = false
            studentView.isHidden = true
        }
    }
    
    @objc func login(){
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            let code = codeTextField.text
            if code != "1234567" {
                let alertVC = UIAlertController(title: "Incorrect Code", message: "The code you entered is incorrect. Please try again.", preferredStyle: UIAlertController.Style.alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)

                alertVC.addAction(okayAction)
                codeTextField.text = ""
                self.present(alertVC, animated: true, completion: nil)

            }
        }
        Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
            
            if let error = error {
                print(error)
                
                self.handleError(error)
                
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
                    self.profileController?.fetchUserAndSetupProfile()
                    self.dismiss(animated: true, completion: {
                        self.loginController?.dismiss(animated: true, completion: {
                        })
                        })
                }
            }
            
            guard let uid = Auth.auth().currentUser?.uid else {
                return
            }
            let ref = Database.database().reference().child("users").child(uid)
            
            if self.typeSegmentedControl.selectedSegmentIndex == 0 {
                ref.child("type").setValue("student")
                let grade = self.gradeTextField.text
                let school = self.schoolTextField.text
                ref.child("grade").setValue(grade)
                ref.child("school").setValue(school)
                
            } else {
                ref.child("type").setValue("mentor")
            }
            
        })

        
        
    }
    
    
}
