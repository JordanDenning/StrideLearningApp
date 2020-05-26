//
//  RegisterType.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/7/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

class RegisterType: UIViewController, UITextFieldDelegate {
    
    var email: String?
    var password: String?
    var messagesController: MessagesController?
    var loginController: LoginController?
    var profileController: ProfileController?
    var plannerController: PlannerOverallController?
    
    let scrollView: UIScrollView = {
        var sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        sv.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        return sv
    }()

    
    lazy var typeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Student", "Staff"])
        sc.translatesAutoresizingMaskIntoConstraints = false
            sc.tintColor = UIColor(r: 16, g: 153, b: 255)
            sc.selectedSegmentIndex = 0
            sc.layer.cornerRadius = 10
        
            
            if #available(iOS 13, *) {
                // selected option color
                sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], for: .selected)
                
                sc.selectedSegmentTintColor = UIColor(r: 16, g: 153, b: 255)
            } else {
                // selected option color
                sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], for: .selected)
                
                // color of other options
                sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
            }
            

            // color of other options
            sc.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)], for: .normal)
        
        sc.addTarget(self, action: #selector(studentMentorChange), for: .valueChanged)
        return sc
    }()
    
    lazy var segmentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Are you a student or a staff member?"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var mentorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please retrieve the access code from your supervisor"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "Role"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let roleTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let roleSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let codeLabel: UILabel = {
        let label = UILabel()
        label.text = "Code"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        label.text = "Please retrieve the access code from your mentor"
        label.textAlignment = NSTextAlignment.center
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "Grade"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
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
    
    let studentCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Code"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let studentCodeTextField: UITextField = {
        let tv = UITextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isSecureTextEntry = true
        
        return tv
    }()
    
    let studentCodeSeparatorView: UIView = {
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
        
        button.addTarget(self, action: #selector(loginStarter), for: .touchUpInside)
        
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
        
        view.addSubview(scrollView)
        
        setupScrollView()
        
        mentorView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func setupScrollView(){
        scrollView.leftAnchor.constraint(equalTo:  view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo:  view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo:  view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo:  view.bottomAnchor).isActive = true

        scrollView.addSubview(typeSegmentedControl)
        scrollView.addSubview(segmentLabel)
        scrollView.addSubview(containerView)
        scrollView.addSubview(registerButton)
        
        setupContainerView()
        setupTypeSegmentedControlAndLabel()
        setupButton()
    }
    
    func setupTypeSegmentedControlAndLabel() {
        segmentLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        segmentLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 75).isActive = true

        //need x, y, width, height constraints
        typeSegmentedControl.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        typeSegmentedControl.topAnchor.constraint(equalTo: segmentLabel.bottomAnchor, constant: 20).isActive = true
        typeSegmentedControl.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -36).isActive = true
        typeSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    func setupContainerView(){
        containerView.topAnchor.constraint(equalTo: typeSegmentedControl.bottomAnchor, constant: 15).isActive = true
        containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: typeSegmentedControl.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        containerView.addSubview(studentView)
        containerView.addSubview(mentorView)
        setupStudentView()
        setupMentorView()
    
    }
    
    func setupStudentView(){
        //studentView
        studentView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        studentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        studentView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        studentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        studentView.addSubview(studentLabel)
        studentView.addSubview(gradeLabel)
        studentView.addSubview(gradeTextField)
        studentView.addSubview(gradeSeparatorView)
        studentView.addSubview(schoolLabel)
        studentView.addSubview(schoolTextField)
        studentView.addSubview(schoolSeparatorView)
        studentView.addSubview(studentCodeLabel)
        studentView.addSubview(studentCodeTextField)
        studentView.addSubview(studentCodeSeparatorView)
        
        gradeTextField.delegate = self
        schoolTextField.delegate = self
        studentCodeTextField.delegate = self
        
        //studentLabel
        studentLabel.topAnchor.constraint(equalTo: studentView.topAnchor, constant: 12).isActive = true
        studentLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        studentLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true
        
        //Grade
        gradeLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 8).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: studentLabel.bottomAnchor, constant: 40).isActive = true
        
        gradeTextField.rightAnchor.constraint(equalTo: studentView.rightAnchor).isActive = true
        gradeTextField.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        gradeTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Grade Separator
        gradeSeparatorView.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor, constant: 12).isActive = true
        gradeSeparatorView.rightAnchor.constraint(equalTo: studentView.rightAnchor, constant: -12).isActive = true
        gradeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        gradeSeparatorView.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //School
        schoolLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 8).isActive = true
        schoolLabel.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        schoolTextField.rightAnchor.constraint(equalTo: studentView.rightAnchor).isActive = true
        schoolTextField.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor, constant: 30).isActive = true
        schoolTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //School Separator
        schoolSeparatorView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 12).isActive = true
        schoolSeparatorView.rightAnchor.constraint(equalTo: studentView.rightAnchor, constant: -12).isActive = true
        schoolSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        schoolSeparatorView.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code
        studentCodeLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 8).isActive = true
        studentCodeLabel.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        studentCodeTextField.rightAnchor.constraint(equalTo: studentView.rightAnchor).isActive = true
        studentCodeTextField.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor, constant: 30).isActive = true
        studentCodeTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code Separator
        studentCodeSeparatorView.topAnchor.constraint(equalTo: studentCodeLabel.bottomAnchor, constant: 12).isActive = true
        studentCodeSeparatorView.rightAnchor.constraint(equalTo: studentView.rightAnchor, constant: -12).isActive = true
        studentCodeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        studentCodeSeparatorView.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
    }
    
    func setupMentorView(){
        //mentorView
        mentorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        mentorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mentorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        mentorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        mentorView.addSubview(mentorLabel)
        mentorView.addSubview(roleLabel)
        mentorView.addSubview(roleTextField)
        mentorView.addSubview(roleSeparatorView)
        mentorView.addSubview(codeLabel)
        mentorView.addSubview(codeTextField)
        mentorView.addSubview(codeSeparatorView)
        
        roleTextField.delegate = self
        codeTextField.delegate = self

        
        //mentorLabel
        mentorLabel.topAnchor.constraint(equalTo: mentorView.topAnchor, constant: 12).isActive = true
        mentorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mentorLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true
        
        //Role
        roleLabel.leftAnchor.constraint(equalTo: mentorView.leftAnchor, constant: 8).isActive = true
        roleLabel.topAnchor.constraint(equalTo: mentorLabel.bottomAnchor, constant: 40).isActive = true
        
        roleTextField.rightAnchor.constraint(equalTo: mentorView.rightAnchor).isActive = true
        roleTextField.topAnchor.constraint(equalTo: roleLabel.topAnchor).isActive = true
        roleTextField.widthAnchor.constraint(equalTo: mentorView.widthAnchor, multiplier: multiplier).isActive = true
        
        //role Separator
        roleSeparatorView.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 12).isActive = true
        roleSeparatorView.rightAnchor.constraint(equalTo: mentorView.rightAnchor, constant: -12).isActive = true
        roleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        roleSeparatorView.widthAnchor.constraint(equalTo: mentorView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code
        codeLabel.leftAnchor.constraint(equalTo: mentorView.leftAnchor, constant: 8).isActive = true
        codeLabel.topAnchor.constraint(equalTo: roleSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        codeTextField.rightAnchor.constraint(equalTo: mentorView.rightAnchor).isActive = true
        codeTextField.topAnchor.constraint(equalTo: roleSeparatorView.bottomAnchor, constant: 30).isActive = true
        codeTextField.widthAnchor.constraint(equalTo: mentorView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code Separator
        codeSeparatorView.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 12).isActive = true
        codeSeparatorView.rightAnchor.constraint(equalTo: mentorView.rightAnchor, constant: -12).isActive = true
        codeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        codeSeparatorView.widthAnchor.constraint(equalTo: mentorView.widthAnchor, multiplier: multiplier).isActive = true
        
        
    }
    
    func setupButton(){
        registerButton.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 12).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
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
    
    @objc func loginStarter(){
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            let code = codeTextField.text
            let role = roleTextField.text
            var accessCode = ""
            
            if (code == "" || role == "") {
                let alertVC = UIAlertController(title: "Empty Fields", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                
                alertVC.addAction(okayAction)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            Database.database().reference().child("mentor-access-code").child("code").observe(.value, with: { (snapshot) in
                
               if let dictionary = snapshot.value as? String {
                    accessCode = dictionary
                if code != accessCode {
                    let alertVC = UIAlertController(title: "Incorrect Code", message: "The code you entered is incorrect. Please try again.", preferredStyle: UIAlertController.Style.alert)
                    
                    let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                    
                    alertVC.addAction(okayAction)
                    self.codeTextField.text = ""
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    self.login()
                }
                }
                
            }, withCancel: nil)
            
        } else{
            let code = studentCodeTextField.text
            let grade = gradeTextField.text
            let school = schoolTextField.text
            var accessCode = ""
            
            if (code == "" || grade == "" || school == "") {
                let alertVC = UIAlertController(title: "Empty Fields", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                
                alertVC.addAction(okayAction)
                self.present(alertVC, animated: true, completion: nil)
            }
            
            
            Database.database().reference().child("student-access-code").child("code").observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? String {
                    accessCode = dictionary
                    if code != accessCode {
                        let alertVC = UIAlertController(title: "Incorrect Code", message: "The code you entered is incorrect. Please try again.", preferredStyle: UIAlertController.Style.alert)
                        
                        let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                        
                        alertVC.addAction(okayAction)
                        self.studentCodeTextField.text = ""
                        self.present(alertVC, animated: true, completion: nil)
                        
                    } else {
                        self.login()
                    }
                }
                
            }, withCancel: nil)
        }
        

        
        
    }
    
    func login(){
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
                    self.plannerController?.checkStudentOrMentor()
                    self.messagesController?.observeUserMessages()
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
                let mentor = ["mentorId": "", "mentorName": "No Current Mentor"]
                ref.child("mentor").setValue(mentor)
                
            } else {
                ref.child("type").setValue("staff")
                let role = self.roleTextField.text
                ref.child("role").setValue(role)
            }
            
        })
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
         
         let userInfo = notification.userInfo!
         var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
         keyboardFrame = self.view.convert(keyboardFrame, from: nil)
         
         var contentInset:UIEdgeInsets = self.scrollView.contentInset
         contentInset.bottom = keyboardFrame.size.height + 20
         scrollView.contentInset = contentInset
     }
     
     @objc func keyboardWillHide(notification:NSNotification){
         
         let contentInset:UIEdgeInsets = UIEdgeInsets.zero
         scrollView.contentInset = contentInset
     }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
