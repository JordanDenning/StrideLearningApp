//
//  RegisterType.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 3/7/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase
import SearchTextField

class RegisterType: UIViewController, UITextFieldDelegate {
    
    var email: String?
    var password: String?
    var messagesController: MessagesController?
    var loginController: LoginController?
    var profileController: ProfileController?
    var plannerController: PlannerOverallController?
    var middleSchoolGrades = ["6th", "7th", "8th"]
    var highSchoolGrades = ["9th", "10th", "11th", "12th"]
    var collegeGrades = ["Freshman", "Sophomore", "Junior", "Senior"]
    var highSchools = [String]()
    var middleSchools = [String]()
    var colleges = [String]()
    var selectedGrade = "No Grade Selected"
    var middleGrade = "No Grade Selected"
    var highGrade = "No Grade Selected"
    var collegeGrade = "No Grade Selected"
    var schoolType = "Middle Schools"
    var selectedRole = "No Role Selected"
    
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
    
    let mentorButton: RadioButton = {
        let button = RadioButton()
        button.label.text = "Mentor"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 0
        button.button.addTarget(self, action: #selector(changeRole(_:)), for: .touchUpInside)

        return button
    }()
    
    let otherStaffButton: RadioButton = {
        let button = RadioButton()
        button.label.text = "Other Staff"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 1
        button.button.addTarget(self, action: #selector(changeRole(_:)), for: .touchUpInside)

        return button
    }()
    
    let roleButtons: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
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
    
    let codeTextField: SearchTextField = {
        let tv = SearchTextField()
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
    
    lazy var schoolSegment: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Middle School", "High School", "College"])
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
        
        sc.addTarget(self, action: #selector(changeSchool), for: .valueChanged)
        return sc
    }()
    
    
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "Grade"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let grade6: RadioButton = {
        let button = RadioButton()
        button.label.text = "6th"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 0
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)

        return button
    }()

    let grade7: RadioButton = {
        let button = RadioButton()
        button.label.text = "7th"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 1
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let grade8: RadioButton = {
        let button = RadioButton()
        button.label.text = "8th"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 2
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let grade9: RadioButton = {
        let button = RadioButton()
        button.label.text = "9th"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 0
        button.button.addTarget(self, action: #selector(changeGrade(_:)), for: .touchUpInside)
        
        return button
    }()
    
    let grade10: RadioButton = {
        let button = RadioButton()
        button.label.text = "10th"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 1
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let grade11: RadioButton = {
        let button = RadioButton()
        button.label.text = "11th"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 2
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let grade12: RadioButton = {
        let button = RadioButton()
        button.label.text = "12th"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 3
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let freshman: RadioButton = {
        let button = RadioButton()
        button.label.text = "Freshman"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 0
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let sophomore: RadioButton = {
        let button = RadioButton()
        button.label.text = "Sophomore"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 1
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let junior: RadioButton = {
        let button = RadioButton()
        button.label.text = "Junior"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 2
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let senior: RadioButton = {
        let button = RadioButton()
        button.label.text = "Senior"
        button.translatesAutoresizingMaskIntoConstraints = false
        button.button.tag = 3
        button.button.addTarget(self, action: #selector(changeGrade), for: .touchUpInside)
        
        return button
    }()
    
    let middleButtons: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let highButtons: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    let collegeButtons: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
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
    
    let middleSchoolTextField: SearchTextField = {
        let tv = SearchTextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let highSchoolTextField: SearchTextField = {
        let tv = SearchTextField()
        tv.translatesAutoresizingMaskIntoConstraints = false

        
        return tv
    }()
    
    let collegeTextField: SearchTextField = {
        let tv = SearchTextField()
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
    
    let studentCodeTextField: SearchTextField = {
        let tv = SearchTextField()
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
        
        fillSchoolArrays()
        setupScrollView()
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
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
    
    func fillSchoolArrays(){
        Database.database().reference().child("Schools").child("Middle Schools").observeSingleEvent(of: .value, with: { (snapshot) in
            
             for child in snapshot.children {
                if let schoolName = child as? DataSnapshot {
                    self.middleSchools.append(schoolName.key)
                }
             }
            self.middleSchoolTextField.filterStrings(self.middleSchools)
         }, withCancel: nil)
        
        Database.database().reference().child("Schools").child("High Schools").observeSingleEvent(of: .value, with: { (snapshot) in
             
             for child in snapshot.children {
                if let schoolName = child as? DataSnapshot {
                    self.highSchools.append(schoolName.key)
                }
             }
            self.highSchoolTextField.filterStrings(self.highSchools)
         }, withCancel: nil)
        
        Database.database().reference().child("Schools").child("Colleges").observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
               if let schoolName = child as? DataSnapshot {
                   self.colleges.append(schoolName.key)
               }
            }
            self.collegeTextField.filterStrings(self.colleges)
        }, withCancel: nil)
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
        containerView.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        containerView.addSubview(studentView)
        containerView.addSubview(mentorView)
        setupStudentView()
        setupMentorView()
        setupButtonViews()
        setupRoleButtons()
    
    }
    
    func setupStudentView(){
        //studentView
        studentView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        studentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        studentView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        studentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        studentView.addSubview(studentLabel)
        studentView.addSubview(schoolSegment)
        studentView.addSubview(gradeLabel)
        studentView.addSubview(middleButtons)
        studentView.addSubview(highButtons)
        studentView.addSubview(collegeButtons)
        studentView.addSubview(schoolLabel)
        studentView.addSubview(middleSchoolTextField)
        studentView.addSubview(highSchoolTextField)
        studentView.addSubview(collegeTextField)
        studentView.addSubview(schoolSeparatorView)
        studentView.addSubview(studentCodeLabel)
        studentView.addSubview(studentCodeTextField)
        studentView.addSubview(studentCodeSeparatorView)
        
        gradeTextField.delegate = self
        middleSchoolTextField.delegate = self
        highSchoolTextField.delegate = self
        collegeTextField.delegate = self
        studentCodeTextField.delegate = self
        
        //studentLabel
        studentLabel.topAnchor.constraint(equalTo: studentView.topAnchor, constant: 12).isActive = true
        studentLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        studentLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true
        
        //School Segment
        schoolSegment.topAnchor.constraint(equalTo: studentLabel.bottomAnchor, constant: 20).isActive = true
        schoolSegment.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        //Grade
        gradeLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 8).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: schoolSegment.bottomAnchor, constant: 20).isActive = true
        
        middleButtons.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor, constant: 40).isActive = true
        middleButtons.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        middleButtons.widthAnchor.constraint(equalToConstant: 275).isActive = true
        middleButtons.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        highButtons.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor, constant: 40).isActive = true
        highButtons.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        highButtons.widthAnchor.constraint(equalToConstant: 275).isActive = true
        highButtons.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        collegeButtons.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor, constant: 40).isActive = true
        collegeButtons.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        collegeButtons.widthAnchor.constraint(equalToConstant: 275).isActive = true
        collegeButtons.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        highButtons.isHidden = true
        collegeButtons.isHidden = true
        middleButtons.isHidden = false
        
        //School
        schoolLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 8).isActive = true
        schoolLabel.topAnchor.constraint(equalTo: middleButtons.bottomAnchor).isActive = true
        
        middleSchoolTextField.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor, constant: 12).isActive = true
        middleSchoolTextField.topAnchor.constraint(equalTo: middleButtons.bottomAnchor).isActive = true
        middleSchoolTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        highSchoolTextField.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor, constant: 12).isActive = true
        highSchoolTextField.topAnchor.constraint(equalTo: middleButtons.bottomAnchor).isActive = true
        highSchoolTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        collegeTextField.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor, constant: 12).isActive = true
        collegeTextField.topAnchor.constraint(equalTo: middleButtons.bottomAnchor).isActive = true
        collegeTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        middleSchoolTextField.isHidden = false
        highSchoolTextField.isHidden = true
        collegeTextField.isHidden = true
        
        //School Separator
        schoolSeparatorView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 12).isActive = true
        schoolSeparatorView.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor, constant: 12).isActive = true
        schoolSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        schoolSeparatorView.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code
        studentCodeLabel.leftAnchor.constraint(equalTo: studentView.leftAnchor, constant: 8).isActive = true
        studentCodeLabel.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        studentCodeTextField.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor, constant: 12).isActive = true
        studentCodeTextField.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor, constant: 30).isActive = true
        studentCodeTextField.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code Separator
        studentCodeSeparatorView.topAnchor.constraint(equalTo: studentCodeLabel.bottomAnchor, constant: 12).isActive = true
        studentCodeSeparatorView.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor, constant: 12).isActive = true
        studentCodeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        studentCodeSeparatorView.widthAnchor.constraint(equalTo: studentView.widthAnchor, multiplier: multiplier).isActive = true
        
    }
    
    func setupButtonViews() {
        //middle school
        middleButtons.addSubview(grade6)
        middleButtons.addSubview(grade7)
        middleButtons.addSubview(grade8)
        
        grade6.topAnchor.constraint(equalTo: middleButtons.topAnchor).isActive = true
        grade6.leadingAnchor.constraint(equalTo: middleButtons.leadingAnchor).isActive = true
        
        grade7.topAnchor.constraint(equalTo: middleButtons.topAnchor).isActive = true
        grade7.leftAnchor.constraint(equalTo: grade6.rightAnchor).isActive = true
        
        grade8.topAnchor.constraint(equalTo: middleButtons.topAnchor).isActive = true
        grade8.leftAnchor.constraint(equalTo: grade7.rightAnchor).isActive = true
        
        //high school
        highButtons.addSubview(grade9)
        highButtons.addSubview(grade10)
        highButtons.addSubview(grade11)
        highButtons.addSubview(grade12)
        
        grade9.topAnchor.constraint(equalTo: highButtons.topAnchor).isActive = true
        grade9.leadingAnchor.constraint(equalTo: highButtons.leadingAnchor).isActive = true
        
        grade10.topAnchor.constraint(equalTo: highButtons.topAnchor).isActive = true
        grade10.leftAnchor.constraint(equalTo: grade9.rightAnchor).isActive = true
        
        grade11.topAnchor.constraint(equalTo: grade10.bottomAnchor, constant: 12).isActive = true
        grade11.leadingAnchor.constraint(equalTo: highButtons.leadingAnchor).isActive = true
        
        grade12.topAnchor.constraint(equalTo: grade10.bottomAnchor, constant: 12).isActive = true
        grade12.leftAnchor.constraint(equalTo: grade11.rightAnchor).isActive = true
        
        //college
        collegeButtons.addSubview(freshman)
        collegeButtons.addSubview(sophomore)
        collegeButtons.addSubview(junior)
        collegeButtons.addSubview(senior)
        
        freshman.topAnchor.constraint(equalTo: collegeButtons.topAnchor).isActive = true
        freshman.leadingAnchor.constraint(equalTo: collegeButtons.leadingAnchor).isActive = true
        
        sophomore.topAnchor.constraint(equalTo: collegeButtons.topAnchor).isActive = true
        sophomore.leftAnchor.constraint(equalTo: freshman.rightAnchor, constant: 30).isActive = true
        
        junior.topAnchor.constraint(equalTo: freshman.bottomAnchor, constant: 12).isActive = true
        junior.leadingAnchor.constraint(equalTo: collegeButtons.leadingAnchor).isActive = true
        
        senior.topAnchor.constraint(equalTo: freshman.bottomAnchor, constant: 12).isActive = true
        senior.leftAnchor.constraint(equalTo: junior.rightAnchor, constant: 30).isActive = true
    }
    
    func setupRoleButtons(){
        roleButtons.addSubview(mentorButton)
        roleButtons.addSubview(otherStaffButton)
        
        mentorButton.topAnchor.constraint(equalTo: roleButtons.topAnchor).isActive = true
        mentorButton.leadingAnchor.constraint(equalTo: roleButtons.leadingAnchor).isActive = true
        
        otherStaffButton.topAnchor.constraint(equalTo: roleButtons.topAnchor).isActive = true
        otherStaffButton.leftAnchor.constraint(equalTo: mentorButton.rightAnchor, constant: 15).isActive = true
    }
    
    func setupMentorView(){
        //mentorView
        mentorView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        mentorView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mentorView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        mentorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
        mentorView.addSubview(mentorLabel)
        mentorView.addSubview(roleLabel)
        mentorView.addSubview(roleButtons)
        mentorView.addSubview(codeLabel)
        mentorView.addSubview(codeTextField)
        mentorView.addSubview(codeSeparatorView)
        
        codeTextField.delegate = self

        
        //mentorLabel
        mentorLabel.topAnchor.constraint(equalTo: mentorView.topAnchor, constant: 12).isActive = true
        mentorLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mentorLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true
        
        //Role
        roleLabel.leftAnchor.constraint(equalTo: mentorView.leftAnchor, constant: 8).isActive = true
        roleLabel.topAnchor.constraint(equalTo: mentorLabel.bottomAnchor, constant: 40).isActive = true
        
        roleButtons.leftAnchor.constraint(equalTo: roleLabel.rightAnchor, constant: 40).isActive = true
        roleButtons.topAnchor.constraint(equalTo: roleLabel.topAnchor).isActive = true
        roleButtons.widthAnchor.constraint(equalToConstant: 275).isActive = true
        roleButtons.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //Code
        codeLabel.leftAnchor.constraint(equalTo: mentorView.leftAnchor, constant: 8).isActive = true
        codeLabel.topAnchor.constraint(equalTo: roleButtons.bottomAnchor, constant: 30).isActive = true
        
        codeTextField.leftAnchor.constraint(equalTo: codeLabel.rightAnchor, constant: 12).isActive = true
        codeTextField.topAnchor.constraint(equalTo: roleButtons.bottomAnchor, constant: 30).isActive = true
        codeTextField.widthAnchor.constraint(equalTo: mentorView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Code Separator
        codeSeparatorView.topAnchor.constraint(equalTo: codeLabel.bottomAnchor, constant: 12).isActive = true
        codeSeparatorView.leftAnchor.constraint(equalTo: codeLabel.rightAnchor, constant: 12).isActive = true
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
    
    @objc func changeSchool(){
        let school = schoolSegment.selectedSegmentIndex
        switch school {
        case 0:
            middleButtons.isHidden = false
            highButtons.isHidden = true
            collegeButtons.isHidden = true
            middleSchoolTextField.isHidden = false
            highSchoolTextField.isHidden = true
            collegeTextField.isHidden = true
            schoolType = "Middle Schools"
            selectedGrade = middleGrade
        case 1:
            middleButtons.isHidden = true
            highButtons.isHidden = false
            collegeButtons.isHidden = true
            middleSchoolTextField.isHidden = true
            highSchoolTextField.isHidden = false
            collegeTextField.isHidden = true
            schoolType = "High Schools"
            selectedGrade = highGrade
        case 2:
            middleButtons.isHidden = true
            highButtons.isHidden = true
            collegeButtons.isHidden = false
            middleSchoolTextField.isHidden = true
            highSchoolTextField.isHidden = true
            collegeTextField.isHidden = false
            schoolType = "Colleges"
            selectedGrade = collegeGrade
        default:
            middleButtons.isHidden = false
            highButtons.isHidden = true
            collegeButtons.isHidden = true
            middleSchoolTextField.isHidden = false
            highSchoolTextField.isHidden = true
            collegeTextField.isHidden = true
            schoolType = "Middle Schools"
            selectedGrade = "No Grade Selected"
        }
    }
    
   @objc func changeGrade(_ sender: UIButton) {
        let school = schoolSegment.selectedSegmentIndex
        let grade = sender.tag
        let selected = UIImage(named: "done4")
        let notSelected = UIImage(named: "notDone")
        switch school {
        case 0:
            switch grade {
            case 0:
                grade6.button.setBackgroundImage(selected, for: .normal)
                grade7.button.setBackgroundImage(notSelected, for: .normal)
                grade8.button.setBackgroundImage(notSelected, for: .normal)
                middleGrade = "6th"
                selectedGrade = "6th"
            case 1:
                grade6.button.setBackgroundImage(notSelected, for: .normal)
                grade7.button.setBackgroundImage(selected, for: .normal)
                grade8.button.setBackgroundImage(notSelected, for: .normal)
                middleGrade = "7th"
                selectedGrade = "7th"
            case 2:
                grade6.button.setBackgroundImage(notSelected, for: .normal)
                grade7.button.setBackgroundImage(notSelected, for: .normal)
                grade8.button.setBackgroundImage(selected, for: .normal)
                middleGrade = "8th"
                selectedGrade = "8th"
            default:
                grade6.button.setBackgroundImage(notSelected, for: .normal)
                grade7.button.setBackgroundImage(notSelected, for: .normal)
                grade8.button.setBackgroundImage(notSelected, for: .normal)
                middleGrade = "No Grade Selected"
                selectedGrade = "No Grade Selected"
            }
        case 1:
            switch grade {
            case 0:
                grade9.button.setBackgroundImage(selected, for: .normal)
                grade10.button.setBackgroundImage(notSelected, for: .normal)
                grade11.button.setBackgroundImage(notSelected, for: .normal)
                grade12.button.setBackgroundImage(notSelected, for: .normal)
                highGrade = "9th"
                selectedGrade = "9th"
            case 1:
                grade9.button.setBackgroundImage(notSelected, for: .normal)
                grade10.button.setBackgroundImage(selected, for: .normal)
                grade11.button.setBackgroundImage(notSelected, for: .normal)
                grade12.button.setBackgroundImage(notSelected, for: .normal)
                highGrade = "10th"
                selectedGrade = "10th"
            case 2:
                grade9.button.setBackgroundImage(notSelected, for: .normal)
                grade10.button.setBackgroundImage(notSelected, for: .normal)
                grade11.button.setBackgroundImage(selected, for: .normal)
                grade12.button.setBackgroundImage(notSelected, for: .normal)
                highGrade = "11th"
                selectedGrade = "11th"
            case 3:
                grade9.button.setBackgroundImage(notSelected, for: .normal)
                grade10.button.setBackgroundImage(notSelected, for: .normal)
                grade11.button.setBackgroundImage(notSelected, for: .normal)
                grade12.button.setBackgroundImage(selected, for: .normal)
                highGrade = "12th"
                selectedGrade = "12th"
            default:
                grade9.button.setBackgroundImage(notSelected, for: .normal)
                grade10.button.setBackgroundImage(notSelected, for: .normal)
                grade11.button.setBackgroundImage(notSelected, for: .normal)
                grade12.button.setBackgroundImage(notSelected, for: .normal)
                highGrade = "No Grade Selected"
                selectedGrade = "No Grade Selected"
            }
        case 2:
            switch grade {
            case 0:
                freshman.button.setBackgroundImage(selected, for: .normal)
                sophomore.button.setBackgroundImage(notSelected, for: .normal)
                junior.button.setBackgroundImage(notSelected, for: .normal)
                senior.button.setBackgroundImage(notSelected, for: .normal)
                collegeGrade = "Freshman"
                selectedGrade = "Freshman"
            case 1:
                freshman.button.setBackgroundImage(notSelected, for: .normal)
                sophomore.button.setBackgroundImage(selected, for: .normal)
                junior.button.setBackgroundImage(notSelected, for: .normal)
                senior.button.setBackgroundImage(notSelected, for: .normal)
                collegeGrade = "Sophomore"
                selectedGrade = "Sophomore"
            case 2:
                freshman.button.setBackgroundImage(notSelected, for: .normal)
                sophomore.button.setBackgroundImage(notSelected, for: .normal)
                junior.button.setBackgroundImage(selected, for: .normal)
                senior.button.setBackgroundImage(notSelected, for: .normal)
                collegeGrade = "Junior"
                selectedGrade = "Junior"
            case 3:
                freshman.button.setBackgroundImage(notSelected, for: .normal)
                sophomore.button.setBackgroundImage(notSelected, for: .normal)
                junior.button.setBackgroundImage(notSelected, for: .normal)
                senior.button.setBackgroundImage(selected, for: .normal)
                collegeGrade = "Senior"
                selectedGrade = "Senior"
            default:
                freshman.button.setBackgroundImage(notSelected, for: .normal)
                sophomore.button.setBackgroundImage(notSelected, for: .normal)
                junior.button.setBackgroundImage(notSelected, for: .normal)
                senior.button.setBackgroundImage(notSelected, for: .normal)
                collegeGrade = "No Grade Selelcted"
                selectedGrade = "No Grade Selelcted"
            }
        default:
            middleButtons.isHidden = false
            highButtons.isHidden = true
            collegeButtons.isHidden = true
        }
    }
    
    @objc func changeRole(_ sender: UIButton) {
        let role = sender.tag
        let selected = UIImage(named: "done4")
        let notSelected = UIImage(named: "notDone")
        switch role {
        case 0:
            mentorButton.button.setBackgroundImage(selected, for: .normal)
            otherStaffButton.button.setBackgroundImage(notSelected, for: .normal)
            selectedRole = "Mentor"
        case 1:
            mentorButton.button.setBackgroundImage(notSelected, for: .normal)
            otherStaffButton.button.setBackgroundImage(selected, for: .normal)
            selectedRole = "Other Staff"
        default:
            mentorButton.button.setBackgroundImage(notSelected, for: .normal)
            otherStaffButton.button.setBackgroundImage(notSelected, for: .normal)
            selectedRole = "No Role Selected"
        }
        
    }

    
    @objc func loginStarter(){
        if typeSegmentedControl.selectedSegmentIndex == 1 {
            let code = codeTextField.text
            var roleFieldsCorrect = false
            var codeFieldsCorrect = false
            var accessCode = ""
            
            if (code == "" || selectedRole == "No Role Selected") {
                let alertVC = UIAlertController(title: "Empty Fields", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                
                roleFieldsCorrect = false
                
                alertVC.addAction(okayAction)
                self.present(alertVC, animated: true, completion: nil)
            } else  {
                roleFieldsCorrect = true
            }
            
            Database.database().reference().child("mentor-access-code").child("code").observe(.value, with: { (snapshot) in
                
               if let dictionary = snapshot.value as? String {
                    accessCode = dictionary
                if code != accessCode {
                    let alertVC = UIAlertController(title: "Incorrect Code", message: "The code you entered is incorrect. Please try again.", preferredStyle: UIAlertController.Style.alert)
                    
                    let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                    
                    codeFieldsCorrect = false
                    
                    alertVC.addAction(okayAction)
                    self.codeTextField.text = ""
                    self.present(alertVC, animated: true, completion: nil)
                    
                } else {
                    codeFieldsCorrect = true
                    if codeFieldsCorrect && roleFieldsCorrect {
                        self.login()
                    }
                }
                }
                
            }, withCancel: nil)
            
        } else{
            let code = studentCodeTextField.text
            var accessCode = ""
            let grade = selectedGrade
            var school = ""
            var noEmptyFields = false
            var gradeFieldCorrect = false
            var schoolFieldCorrect = false
            var codeFieldCorrect = false
            
            var schoolArray = [String()]
            var gradeArray = [String()]
            switch schoolType {
            case "Middle Schools":
                school = middleSchoolTextField.text!
                schoolArray = middleSchools
                gradeArray = middleSchoolGrades
            case "High Schools":
                school = highSchoolTextField.text!
                schoolArray = highSchools
                gradeArray = highSchoolGrades
            case "Colleges":
                school = collegeTextField.text!
                schoolArray = colleges
                gradeArray = collegeGrades
            default:
                school = ""
            }
            
            if (code == "" || grade == "No Grade Selected" || school == "") {
                let alertVC = UIAlertController(title: "Empty Fields", message: "Please fill out all fields.", preferredStyle: UIAlertController.Style.alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                
                noEmptyFields = false
                
                alertVC.addAction(okayAction)
                self.present(alertVC, animated: true, completion: nil)
            } else {
                noEmptyFields = true
            }
            
            if !gradeArray.contains(selectedGrade) {
                let alert = UIAlertController(title: "Invalid Grade", message: "Please select a grade.", preferredStyle: UIAlertController.Style.alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                })
                
                gradeFieldCorrect = false
                
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                gradeFieldCorrect = true
            }
            
            if !schoolArray.contains(school) {
                let alert = UIAlertController(title: "Invalid School", message: "Please select a school from the list, or choose 'Other' if you don't see your school.", preferredStyle: UIAlertController.Style.alert)
                
                let okayAction = UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                    self.middleSchoolTextField.text = ""
                    self.highSchoolTextField.text = ""
                    self.collegeTextField.text = ""
                })
                
                schoolFieldCorrect = false
                
                alert.addAction(okayAction)
                self.present(alert, animated: true, completion: nil)
            } else {
                schoolFieldCorrect = true
            }
            
            Database.database().reference().child("student-access-code").child("code").observe(.value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? String {
                    accessCode = dictionary
                    if code != accessCode {
                        let alertVC = UIAlertController(title: "Incorrect Code", message: "The code you entered is incorrect. Please try again.", preferredStyle: UIAlertController.Style.alert)
                        
                        let okayAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
                        
                        codeFieldCorrect = false
                        
                        alertVC.addAction(okayAction)
                        self.studentCodeTextField.text = ""
                        self.present(alertVC, animated: true, completion: nil)
                        
                    } else {
                        codeFieldCorrect = true
                        if noEmptyFields && gradeFieldCorrect && schoolFieldCorrect && codeFieldCorrect {
                            self.login()
                        }
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
                var school = ""
                switch self.schoolType {
                case "Middle Schools":
                    school = self.middleSchoolTextField.text!
                case "High Schools":
                    school = self.highSchoolTextField.text!
                case "Colleges":
                    school = self.collegeTextField.text!
                default:
                    school = ""
                }
                ref.child("grade").setValue(self.selectedGrade)
                ref.child("school").setValue(school)
                let mentor = ["mentorId": "", "mentorName": "No Current Mentor"]
                ref.child("mentor").setValue(mentor)
                
                let schoolRef = Database.database().reference().child("Schools").child(self.schoolType).child(school)
                
                schoolRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let studentCount = snapshot.value as? Int{
                        let count = studentCount + 1
                        schoolRef.setValue(count)
                    }
                }, withCancel: nil)
                
            } else {
                ref.child("type").setValue("staff")
                ref.child("role").setValue(self.selectedRole)
                ref.child("student").setValue("")
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
    
}
