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
import SearchTextField

class EditProfileController: UIViewController, UITextFieldDelegate {
    
    var profileController: ProfileController?
    var user: User?
    var viewContainsMentorView = false
    var viewContainsStudentView = false
    
    let scrollView: UIScrollView = {
        var sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = .white
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height - 200
        sv.contentSize = CGSize(width: screenWidth, height: screenHeight)
        
        return sv
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let firstNameTextField: SearchTextField = {
        let tv = SearchTextField()
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
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lastNameTextField: SearchTextField = {
        let tv = SearchTextField()
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
    
    let gradeSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let roleLabel: UILabel = {
        let label = UILabel()
        label.text = "Role"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let roleTextField: SearchTextField = {
        let tv = SearchTextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let roleSeparatorView: UIView = {
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
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let emailTextField: SearchTextField = {
        let tv = SearchTextField()
        tv.translatesAutoresizingMaskIntoConstraints = false
        
        return tv
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let studentInputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let mentorInputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 245, g:245, b:245)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveData))
        
        navigationItem.title = "Edit Profile"
        
        view.addSubview(scrollView)
        
        setupScrollView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupScrollView(){
        scrollView.leftAnchor.constraint(equalTo:  view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo:  view.topAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo:  view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo:  view.bottomAnchor).isActive = true
        
        scrollView.addSubview(studentInputsContainerView)
        scrollView.addSubview(mentorInputsContainerView)
        
        fetchUserAndSetupProfile()
    }
    
    func fetchUserAndSetupProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.user = User(dictionary: dictionary)
                if self.user?.type == "staff" {
                    self.setupMentorEditInfo(self.user!)
                    self.viewContainsMentorView = true
                    if self.viewContainsStudentView == true {
                        self.studentInputsContainerView.removeFromSuperview()
                        self.viewContainsStudentView = false
                    }
                }
                else {
                    self.setupStudentEditInfo(self.user!)
                    self.viewContainsStudentView = true
                    if self.viewContainsMentorView == true {
                        self.mentorInputsContainerView.removeFromSuperview()
                        self.viewContainsMentorView = false
                    }
                }
                
            }
            
        }, withCancel: nil)
    }
    
    func setupStudentEditInfo(_ user: User) {
        studentInputsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        studentInputsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        studentInputsContainerView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        studentInputsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true
        
        studentInputsContainerView.addSubview(firstNameLabel)
        studentInputsContainerView.addSubview(firstNameTextField)
        studentInputsContainerView.addSubview(firstNameSeparatorView)
        studentInputsContainerView.addSubview(lastNameLabel)
        studentInputsContainerView.addSubview(lastNameTextField)
        studentInputsContainerView.addSubview(lastNameSeparatorView)
        studentInputsContainerView.addSubview(schoolSegment)
        studentInputsContainerView.addSubview(gradeLabel)
        studentInputsContainerView.addSubview(middleButtons)
        studentInputsContainerView.addSubview(highButtons)
        studentInputsContainerView.addSubview(collegeButtons)
        studentInputsContainerView.addSubview(gradeSeparatorView)
        studentInputsContainerView.addSubview(schoolLabel)
        studentInputsContainerView.addSubview(middleSchoolTextField)
        studentInputsContainerView.addSubview(highSchoolTextField)
        studentInputsContainerView.addSubview(collegeTextField)
        studentInputsContainerView.addSubview(schoolSeparatorView)
        studentInputsContainerView.addSubview(emailLabel)
        studentInputsContainerView.addSubview(emailTextField)
        studentInputsContainerView.addSubview(emailSeparatorView)
        
        firstNameTextField.text = user.firstName
        firstNameTextField.font = UIFont.systemFont(ofSize: 14)
        self.firstNameTextField.delegate = self
        lastNameTextField.text = user.lastName
        lastNameTextField.font = UIFont.systemFont(ofSize: 14)
        self.lastNameTextField.delegate = self

        if let grade = user.grade{
            setupButtonsAndSegment(grade: grade)
        }

        middleSchoolTextField.text = user.school
        highSchoolTextField.text = user.school
        collegeTextField.text = user.school
        
        middleSchoolTextField.font = UIFont.systemFont(ofSize: 14)
        highSchoolTextField.font = UIFont.systemFont(ofSize: 14)
        collegeTextField.font = UIFont.systemFont(ofSize: 14)

        middleSchoolTextField.delegate = self
        highSchoolTextField.delegate = self
        collegeTextField.delegate = self
        
        emailTextField.text = user.email
        emailTextField.font = UIFont.systemFont(ofSize: 14)
        self.emailTextField.delegate = self
        
        
        let multiplier = 0.65 as CGFloat

        //First Name
        firstNameLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 8).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: studentInputsContainerView.topAnchor).isActive = true

        firstNameTextField.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: studentInputsContainerView.topAnchor).isActive = true
        firstNameTextField.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true

        //First Name Separator
        firstNameSeparatorView.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 12).isActive = true
        firstNameSeparatorView.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor, constant: -12).isActive = true
        firstNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        firstNameSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Last Name
        lastNameLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 8).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        lastNameTextField.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        lastNameTextField.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Last Name Separator
        lastNameSeparatorView.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 12).isActive = true
        lastNameSeparatorView.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor, constant: -12).isActive = true
        lastNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lastNameSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Email
        emailLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 8).isActive = true
        emailLabel.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        emailTextField.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Email Separator
        emailSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor, constant: -12).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //School Segment
        schoolSegment.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor, constant: 30).isActive = true
        schoolSegment.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        //Grade
        gradeLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 8).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: schoolSegment.bottomAnchor, constant: 30).isActive = true
        
        middleButtons.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor, constant: 45).isActive = true
        middleButtons.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        middleButtons.widthAnchor.constraint(equalToConstant: 275).isActive = true
        middleButtons.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        highButtons.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor, constant: 45).isActive = true
        highButtons.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        highButtons.widthAnchor.constraint(equalToConstant: 275).isActive = true
        highButtons.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        collegeButtons.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor, constant: 45).isActive = true
        collegeButtons.topAnchor.constraint(equalTo: gradeLabel.topAnchor).isActive = true
        collegeButtons.widthAnchor.constraint(equalToConstant: 275).isActive = true
        collegeButtons.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        //School
        schoolLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 8).isActive = true
        schoolLabel.topAnchor.constraint(equalTo: middleButtons.bottomAnchor, constant: 8).isActive = true
        
        middleSchoolTextField.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor).isActive = true
        middleSchoolTextField.topAnchor.constraint(equalTo: middleButtons.bottomAnchor, constant: 8).isActive = true
        middleSchoolTextField.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        highSchoolTextField.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor).isActive = true
        highSchoolTextField.topAnchor.constraint(equalTo: middleButtons.bottomAnchor, constant: 8).isActive = true
        highSchoolTextField.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        collegeTextField.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor).isActive = true
        collegeTextField.topAnchor.constraint(equalTo: middleButtons.bottomAnchor, constant: 8).isActive = true
        collegeTextField.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        middleSchoolTextField.isHidden = false
        highSchoolTextField.isHidden = true
        collegeTextField.isHidden = true
        
        //School Separator
        schoolSeparatorView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor, constant: 12).isActive = true
        schoolSeparatorView.rightAnchor.constraint(equalTo: studentInputsContainerView.rightAnchor, constant: -12).isActive = true
        schoolSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        schoolSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
    }
    
    func setupMentorEditInfo(_ user: User) {
        mentorInputsContainerView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        mentorInputsContainerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        mentorInputsContainerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        mentorInputsContainerView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -10).isActive = true
        
        mentorInputsContainerView.addSubview(firstNameLabel)
        mentorInputsContainerView.addSubview(firstNameTextField)
        mentorInputsContainerView.addSubview(firstNameSeparatorView)
        mentorInputsContainerView.addSubview(lastNameLabel)
        mentorInputsContainerView.addSubview(lastNameTextField)
        mentorInputsContainerView.addSubview(lastNameSeparatorView)
        mentorInputsContainerView.addSubview(roleLabel)
        mentorInputsContainerView.addSubview(roleTextField)
        mentorInputsContainerView.addSubview(roleSeparatorView)
        mentorInputsContainerView.addSubview(emailLabel)
        mentorInputsContainerView.addSubview(emailTextField)
        mentorInputsContainerView.addSubview(emailSeparatorView)
        
        firstNameTextField.text = user.firstName
        firstNameTextField.font = UIFont.systemFont(ofSize: 14)
        self.firstNameTextField.delegate = self
        lastNameTextField.text = user.lastName
        lastNameTextField.font = UIFont.systemFont(ofSize: 14)
        self.lastNameTextField.delegate = self
        roleTextField.text = user.role
        roleTextField.font = UIFont.systemFont(ofSize: 14)
        self.roleTextField.delegate = self
        emailTextField.text = user.email
        emailTextField.font = UIFont.systemFont(ofSize: 14)
        self.emailTextField.delegate = self
        
        let multiplier = 0.65 as CGFloat
        
        //First Name
        firstNameLabel.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 8).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: mentorInputsContainerView.topAnchor).isActive = true
        
        firstNameTextField.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: mentorInputsContainerView.topAnchor).isActive = true
        firstNameTextField.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //First Name Separator
        firstNameSeparatorView.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 12).isActive = true
        firstNameSeparatorView.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor, constant: -12).isActive = true
        firstNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        firstNameSeparatorView.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Last Name
        lastNameLabel.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 8).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        lastNameTextField.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        lastNameTextField.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Last Name Separator
        lastNameSeparatorView.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 12).isActive = true
        lastNameSeparatorView.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor, constant: -12).isActive = true
        lastNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lastNameSeparatorView.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Role
        roleLabel.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 8).isActive = true
        roleLabel.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        roleTextField.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor).isActive = true
        roleTextField.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor, constant: 30).isActive = true
        roleTextField.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Role Separator
        roleSeparatorView.topAnchor.constraint(equalTo: roleLabel.bottomAnchor, constant: 12).isActive = true
        roleSeparatorView.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor, constant: -12).isActive = true
        roleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        roleSeparatorView.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Email
        emailLabel.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 8).isActive = true
        emailLabel.topAnchor.constraint(equalTo: roleSeparatorView.bottomAnchor, constant: 30).isActive = true
        
        emailTextField.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: roleSeparatorView.bottomAnchor, constant: 30).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
        //Email Separator
        emailSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 12).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: mentorInputsContainerView.rightAnchor, constant: -12).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor, multiplier: multiplier).isActive = true
        
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
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveData() {
        let firstName = firstNameTextField.text
        let lastName = lastNameTextField.text
        let grade = gradeTextField.text
        let role = roleTextField.text
        let school = schoolTextField.text
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
                                    }
                                })
                                let values = ["name": firstName! + " " + lastName!, "firstName": firstName, "lastName": lastName, "grade": grade, "role": role, "school": school, "email": email] as [String : AnyObject]
                                
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
            let values = ["name": firstName! + " " + lastName!, "firstName": firstName, "lastName": lastName, "grade": grade, "role": role, "school": school, "email": email] as [String : AnyObject]
            
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
        profileController?.updateData()
    }
    
    
     @objc func keyboardWillShow(notification:NSNotification){
         
         let userInfo = notification.userInfo!
         var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
         keyboardFrame = self.view.convert(keyboardFrame, from: nil)
         
         var contentInset:UIEdgeInsets = self.scrollView.contentInset
         contentInset.bottom = keyboardFrame.size.height + 10
         scrollView.contentInset = contentInset
     }
     
     @objc func keyboardWillHide(notification:NSNotification){
         
         let contentInset:UIEdgeInsets = UIEdgeInsets.zero
         scrollView.contentInset = contentInset
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
    
    func setupButtonsAndSegment(grade: String){
        let selected = UIImage(named: "done4")
        switch grade {
        case "6th":
            grade6.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 0
            middleButtons.isHidden = false
            highButtons.isHidden = true
            collegeButtons.isHidden = true
            middleGrade = "6th"
            selectedGrade = "6th"
            schoolType = "Middle Schools"
        case "7th":
            grade7.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 0
            middleButtons.isHidden = false
            highButtons.isHidden = true
            collegeButtons.isHidden = true
            middleGrade = "7th"
            selectedGrade = "7th"
            schoolType = "Middle Schools"
        case "8th":
            grade8.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 0
            middleButtons.isHidden = false
            highButtons.isHidden = true
            collegeButtons.isHidden = true
            middleGrade = "8th"
            selectedGrade = "8th"
            schoolType = "Middle Schools"
        case "9th":
            grade9.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 1
            middleButtons.isHidden = true
            highButtons.isHidden = false
            collegeButtons.isHidden = true
            highGrade = "9th"
            selectedGrade = "9th"
            schoolType = "High Schools"
        case "10th":
            grade10.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 1
            middleButtons.isHidden = true
            highButtons.isHidden = false
            collegeButtons.isHidden = true
            highGrade = "10th"
            selectedGrade = "10th"
            schoolType = "High Schools"
        case "11th":
            grade11.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 1
            middleButtons.isHidden = true
            highButtons.isHidden = false
            collegeButtons.isHidden = true
            highGrade = "11th"
            selectedGrade = "11th"
            schoolType = "High Schools"
        case "12th":
            grade12.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 1
            middleButtons.isHidden = true
            highButtons.isHidden = false
            collegeButtons.isHidden = true
            highGrade = "12th"
            selectedGrade = "12th"
            schoolType = "High Schools"
        case "Freshman":
            freshman.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 2
            middleButtons.isHidden = true
            highButtons.isHidden = true
            collegeButtons.isHidden = false
            collegeGrade = "Freshman"
            selectedGrade = "Freshman"
            schoolType = "Colleges"
        case "Sophomore":
            sophomore.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 2
            middleButtons.isHidden = true
            highButtons.isHidden = true
            collegeButtons.isHidden = false
            collegeGrade = "Sophomore"
            selectedGrade = "Sophomore"
            schoolType = "Colleges"
        case "Junior":
            junior.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 2
            middleButtons.isHidden = true
            highButtons.isHidden = true
            collegeButtons.isHidden = false
            collegeGrade = "Junior"
            selectedGrade = "Junior"
            schoolType = "Colleges"
        case "Senior":
            senior.button.setBackgroundImage(selected, for: .normal)
            schoolSegment.selectedSegmentIndex = 2
            middleButtons.isHidden = true
            highButtons.isHidden = true
            collegeButtons.isHidden = false
            collegeGrade = "Senior"
            selectedGrade = "Senior"
            schoolType = "Colleges"
            
        default:
            schoolSegment.selectedSegmentIndex = 0
            middleButtons.isHidden = false
            highButtons.isHidden = true
            collegeButtons.isHidden = true
            selectedGrade = "No Current Grade"
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
    
    @objc func changeGrade(_ sender: UIButton){
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
}
