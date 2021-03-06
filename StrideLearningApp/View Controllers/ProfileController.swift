//
//  ProfileController.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/3/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var messagesController: MessagesController?
    var plannerController: PlannerOverallController?
    var user: User?
    var viewContainsMentorView = false
    var viewContainsStudentView = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 245, g:245, b:245)
        view.addSubview(imageandNameView)
        view.addSubview(buttonsContainerView)
        
        //navigation bar color
        let navBackgroundImage = UIImage(named:"navBarSmall")?.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
        self.navigationController?.navigationBar.setBackgroundImage(navBackgroundImage,
                                                                    for: .default)
        //navigation title properties
        self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font: UIFont(name: "MarkerFelt-Thin", size: 20) ?? UIFont.systemFont(ofSize: 20)]

        //navigation button items
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.navigationItem.rightBarButtonItem = nil

        fetchUserAndSetupProfile()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        
    }

    let imageandNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        
        return view
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor(r:16, g:153, b:255).cgColor
        imageView.layer.cornerRadius = 70
        //half of 140 which is height and width
        imageView.clipsToBounds = true
        
        if UIScreen.main.sizeType == .iPhone5 {
            // decrease size of profile picture
            imageView.layer.cornerRadius = 50
        }
        else if UIScreen.main.sizeType == .iPhone6 {
            // decrease size of profile picture
            imageView.layer.cornerRadius = 60
        }
        
        return imageView
    }()
    
    lazy var addProfilePicture: UIImageView = {
        var imageView = UIImageView()
        var image = UIImage(named: "task_v3")
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor(r:16, g:153, b:255).cgColor
        imageView.layer.cornerRadius = 70
        imageView.image = imageView.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        imageView.tintColor = UIColor(r:16, g:153, b:255)
        
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont(name: "MarkerFelt-Thin", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let studentInputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let mentorInputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
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

    let grade: UILabel = {
        let label = UILabel()
        label.text = "Grade"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let role: UILabel = {
        let label = UILabel()
        label.text = "Role"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let school: UILabel = {
        let label = UILabel()
        label.text = "School"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let schoolSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mentorLabel: UILabel = {
        let label = UILabel()
        label.text = "Mentor"
        label.textColor = UIColor(r: 16, g: 153, b: 255)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let mentor: UILabel = {
        let label = UILabel()
        label.text = "Mentor"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let mentorSeparatorView: UIView = {
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
    
    let email: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let buttonsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        
        return view
    }()
    
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.setTitle("Edit Profile", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 5
        
        //border
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 16, g: 153, b: 255).cgColor
        
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        return button
    }()
    
    lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.setTitle("Change Password", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 5
        
        //border
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 16, g: 153, b: 255).cgColor
        
        button.addTarget(self, action: #selector(editPassword), for: .touchUpInside)
        
        return button
    }()
    
    
    func setupProfileImageView(_ user: User) {
        imageandNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageandNameView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageandNameView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageandNameView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x, y, width, height constraints
        imageandNameView.addSubview(profileImageView)
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        imageandNameView.addSubview(addProfilePicture)

        profileImageView.centerXAnchor.constraint(equalTo: imageandNameView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: imageandNameView.centerYAnchor, constant: -20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        addProfilePicture.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 40).isActive = true
        addProfilePicture.centerXAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: -7).isActive = true
        addProfilePicture.widthAnchor.constraint(equalToConstant: 30).isActive = true
        addProfilePicture.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        if UIScreen.main.sizeType == .iPhone5 {
            // decrease size of profile picture
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        }
        
        if UIScreen.main.sizeType == .iPhone6 {
            // decrease size of profile picture
            profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        }

    
        imageandNameView.addSubview(userName)
        userName.text = user.name
    
        userName.centerXAnchor.constraint(equalTo: imageandNameView.centerXAnchor).isActive = true
        userName.bottomAnchor.constraint(equalTo: imageandNameView.bottomAnchor, constant: -10).isActive = true
    }
    
    var studentInputsContainerViewHeightAnchor: NSLayoutConstraint?
    var mentorInputsContainerViewHeightAnchor: NSLayoutConstraint?
    var gradeLabelHeightAnchor: NSLayoutConstraint?
    var gradeTextFieldHeightAnchor: NSLayoutConstraint?
    var roleLabelHeightAnchor: NSLayoutConstraint?
    var roleTextFieldHeightAnchor: NSLayoutConstraint?
    var schoolTextFieldHeightAnchor: NSLayoutConstraint?
    var schoolLabelHeightAnchor: NSLayoutConstraint?
    var mentorTextFieldHeightAnchor: NSLayoutConstraint?
    var mentorLabelHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var emailLabelHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordConfirmTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupStudentInputsContainerView(_ user: User) {
        
        view.addSubview(studentInputsContainerView)
        
        //need x, y, width, height constraints
        studentInputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        studentInputsContainerView.topAnchor.constraint(equalTo: imageandNameView.bottomAnchor).isActive = true
        studentInputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        if UIScreen.main.sizeType == .iPhone5 {
            // decrease size of input container
            studentInputsContainerViewHeightAnchor = studentInputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        }
        else if UIScreen.main.sizeType == .iPhone6 {
            // decrease size of input container
            studentInputsContainerViewHeightAnchor = studentInputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        }
        else{
            studentInputsContainerViewHeightAnchor = studentInputsContainerView.heightAnchor.constraint(equalToConstant: 180)
        }
        studentInputsContainerViewHeightAnchor?.isActive = true
        

        if UIScreen.main.sizeType == .iPhone5 {
            studentInputsContainerViewHeightAnchor = studentInputsContainerView.heightAnchor.constraint(equalToConstant: 170)
            studentInputsContainerViewHeightAnchor?.isActive = true
        }


        grade.text = user.grade
        school.text = user.school
        email.text = user.email
        mentor.text = user.mentor?["mentorName"] as? String
        
        
        studentInputsContainerView.addSubview(gradeLabel)
        studentInputsContainerView.addSubview(grade)
        studentInputsContainerView.addSubview(gradeSeparatorView)
        studentInputsContainerView.addSubview(schoolLabel)
        studentInputsContainerView.addSubview(school)
        studentInputsContainerView.addSubview(schoolSeparatorView)
        studentInputsContainerView.addSubview(mentorLabel)
        studentInputsContainerView.addSubview(mentor)
        studentInputsContainerView.addSubview(mentorSeparatorView)
        studentInputsContainerView.addSubview(emailLabel)
        studentInputsContainerView.addSubview(email)
        studentInputsContainerView.addSubview(emailSeparatorView)
        
        //Grade Label
        gradeLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 18).isActive = true
        gradeLabel.rightAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 100).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: studentInputsContainerView.topAnchor).isActive = true
        
        gradeLabelHeightAnchor = gradeLabel.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/4)
        gradeLabelHeightAnchor?.isActive = true
        
        //Grade Constraints
        grade.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor).isActive = true
        grade.topAnchor.constraint(equalTo: studentInputsContainerView.topAnchor).isActive = true
        grade.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        
        gradeTextFieldHeightAnchor = grade.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/4)
        gradeTextFieldHeightAnchor?.isActive = true
        
        //Grade Separator View
        gradeSeparatorView.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor).isActive = true
        gradeSeparatorView.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor).isActive = true
        gradeSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        gradeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //School Label
        schoolLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 18).isActive = true
        schoolLabel.rightAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 100).isActive = true
        schoolLabel.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor).isActive = true
        
        schoolLabelHeightAnchor = schoolLabel.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/4)
        schoolLabelHeightAnchor?.isActive = true
        
        //School Constraints
        school.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor).isActive = true
        school.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor).isActive = true
        school.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        
        schoolTextFieldHeightAnchor = school.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/4)
        schoolTextFieldHeightAnchor?.isActive = true
        
        //School Separator View
        schoolSeparatorView.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor).isActive = true
        schoolSeparatorView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor).isActive = true
        schoolSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        schoolSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Mentor Label
        mentorLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 18).isActive = true
        mentorLabel.rightAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 100).isActive = true
        mentorLabel.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor).isActive = true
        
        mentorLabelHeightAnchor = mentorLabel.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/4)
        mentorLabelHeightAnchor?.isActive = true
        
        //Mentor
        mentor.leftAnchor.constraint(equalTo: mentorLabel.rightAnchor).isActive = true
        mentor.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor).isActive = true
        mentor.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        
        mentorTextFieldHeightAnchor = mentor.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/4)
         mentorTextFieldHeightAnchor?.isActive = true
        
        //Email Separator View
        mentorSeparatorView.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor).isActive = true
        mentorSeparatorView.topAnchor.constraint(equalTo: mentorLabel.bottomAnchor).isActive = true
        mentorSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        mentorSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        //Email Label
        emailLabel.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 18).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor, constant: 100).isActive = true
        emailLabel.topAnchor.constraint(equalTo: mentorSeparatorView.bottomAnchor).isActive = true
        
        emailLabelHeightAnchor = emailLabel.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/4)
        emailLabelHeightAnchor?.isActive = true
        
        //Email
        email.leftAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true
        email.topAnchor.constraint(equalTo: mentorSeparatorView.bottomAnchor).isActive = true
        email.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        
        emailTextFieldHeightAnchor = email.heightAnchor.constraint(equalTo: studentInputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //Email Separator View
        emailSeparatorView.leftAnchor.constraint(equalTo: studentInputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: studentInputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupMentorInputsContainerView(_ user: User) {
        
        view.addSubview(mentorInputsContainerView)
        
        //need x, y, width, height constraints
        mentorInputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mentorInputsContainerView.topAnchor.constraint(equalTo: imageandNameView.bottomAnchor).isActive = true
        mentorInputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mentorInputsContainerViewHeightAnchor = mentorInputsContainerView.heightAnchor.constraint(equalToConstant: 120)
        mentorInputsContainerViewHeightAnchor?.isActive = true
        
        
        role.text = user.role
        email.text = user.email
        
        
        mentorInputsContainerView.addSubview(roleLabel)
        mentorInputsContainerView.addSubview(role)
        mentorInputsContainerView.addSubview(roleSeparatorView)
        mentorInputsContainerView.addSubview(emailLabel)
        mentorInputsContainerView.addSubview(email)
        mentorInputsContainerView.addSubview(emailSeparatorView)
        
        //Role Label
        roleLabel.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 18).isActive = true
        roleLabel.rightAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 100).isActive = true
        roleLabel.topAnchor.constraint(equalTo: mentorInputsContainerView.topAnchor).isActive = true
        
        roleLabelHeightAnchor = roleLabel.heightAnchor.constraint(equalTo: mentorInputsContainerView.heightAnchor, multiplier: 1/2)
        roleLabelHeightAnchor?.isActive = true
        
        //Role Constraints
        role.leftAnchor.constraint(equalTo: roleLabel.rightAnchor).isActive = true
        role.topAnchor.constraint(equalTo: mentorInputsContainerView.topAnchor).isActive = true
        role.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor).isActive = true
        
        roleTextFieldHeightAnchor = role.heightAnchor.constraint(equalTo: mentorInputsContainerView.heightAnchor, multiplier: 1/2)
        roleTextFieldHeightAnchor?.isActive = true
        
        //Role Separator View
        roleSeparatorView.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor).isActive = true
        roleSeparatorView.topAnchor.constraint(equalTo: roleLabel.bottomAnchor).isActive = true
        roleSeparatorView.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor).isActive = true
        roleSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Email Label
        emailLabel.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 18).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor, constant: 100).isActive = true
        emailLabel.topAnchor.constraint(equalTo: roleSeparatorView.bottomAnchor).isActive = true
        
        emailLabelHeightAnchor = emailLabel.heightAnchor.constraint(equalTo: mentorInputsContainerView.heightAnchor, multiplier: 1/2)
        emailLabelHeightAnchor?.isActive = true
        
        //Email
        email.leftAnchor.constraint(equalTo: emailLabel.rightAnchor).isActive = true
        email.topAnchor.constraint(equalTo: roleSeparatorView.bottomAnchor).isActive = true
        
        email.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = email.heightAnchor.constraint(equalTo: mentorInputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        //Email Separator View
        emailSeparatorView.leftAnchor.constraint(equalTo: mentorInputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: mentorInputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setupStudentButtonView() {
        buttonsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsContainerView.topAnchor.constraint(equalTo: studentInputsContainerView.bottomAnchor, constant: 8).isActive = true
        buttonsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        buttonsContainerView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        buttonsContainerView.addSubview(editProfileButton)
        buttonsContainerView.addSubview(changePasswordButton)
        
        editProfileButton.centerXAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor, constant: 10).isActive = true
        editProfileButton.widthAnchor.constraint(equalTo: buttonsContainerView.widthAnchor).isActive = true
        if UIScreen.main.sizeType == .iPhone5 {
            // decrease height of button
            editProfileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else{
            editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
        
        changePasswordButton.centerXAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor).isActive = true
        changePasswordButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 10).isActive = true
        changePasswordButton.widthAnchor.constraint(equalTo: buttonsContainerView.widthAnchor).isActive = true
        if UIScreen.main.sizeType == .iPhone5 {
            // decrease height of button
            changePasswordButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else{
            changePasswordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }

    }
    
    func setupMentorButtonView() {
        buttonsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsContainerView.topAnchor.constraint(equalTo: mentorInputsContainerView.bottomAnchor, constant: 8).isActive = true
        buttonsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        buttonsContainerView.heightAnchor.constraint(equalToConstant: 110).isActive = true
        
        buttonsContainerView.addSubview(editProfileButton)
        buttonsContainerView.addSubview(changePasswordButton)
        
        editProfileButton.centerXAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: buttonsContainerView.topAnchor, constant: 10).isActive = true
        editProfileButton.widthAnchor.constraint(equalTo: buttonsContainerView.widthAnchor).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        changePasswordButton.centerXAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor).isActive = true
        changePasswordButton.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 10).isActive = true
        changePasswordButton.widthAnchor.constraint(equalTo: buttonsContainerView.widthAnchor).isActive = true
        changePasswordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func fetchUserAndSetupProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                self.user = User(dictionary: dictionary)
                if self.user?.type == "staff" {
                    self.setupProfileImageView(self.user!)
                    self.setupMentorInputsContainerView(self.user!)
                    self.setupMentorButtonView()
                    self.viewContainsMentorView = true
                    if self.viewContainsStudentView == true {
                        self.studentInputsContainerView.removeFromSuperview()
                        self.viewContainsStudentView = false
                    }
                }
                else {
                    self.setupProfileImageView(self.user!)
                    self.setupStudentInputsContainerView(self.user!)
                    self.setupStudentButtonView()
                    self.viewContainsStudentView = true
                    if self.viewContainsMentorView == true {
                        self.mentorInputsContainerView.removeFromSuperview()
                        self.viewContainsMentorView = false
                    }
                }
                
            }
            
        }, withCancel: nil)
    }
    
    func updateData(){
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User(dictionary: dictionary)
                self.grade.text = user.grade
                self.role.text = user.role
                self.school.text = user.school
                self.userName.text = user.name
                self.email.text = user.email
                if let profileImageUrl = user.profileImageUrl {
                    self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
                }
                
            }
            
        }, withCancel: nil)
        
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
        
        //change image in firebase here
        updateProfilePicture()
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func updateProfilePicture() {
        let imageName = NSUUID().uuidString //get unique image name to use for uploading and storing
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (_, err) in
                
                if let error = err {
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
                    
                    let values = [ "profileImageUrl": url.absoluteString] as [String : AnyObject]
                    
                    guard let uid = Auth.auth().currentUser?.uid else {
                        return
                    }
                    
                    let ref = Database.database().reference()
                    let usersReference = ref.child("users").child(uid)
                    
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if let err = err {
                            print(err)
                            return
                        }
                        
                        //else have alert saying changes saved successfully
                        
                    })
                    
                })

            })
        }
    }
    
    @objc func editProfile(){
        let editProfileContoller = EditProfileController()
        editProfileContoller.profileController = self
        let navController = UINavigationController(rootViewController: editProfileContoller)
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func editPassword(){
        let editPasswordController = EditPasswordController()
        editPasswordController.profileController = self
        let navController = UINavigationController(rootViewController: editPasswordController)
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LoginController()
        loginController.modalPresentationStyle = .fullScreen
        loginController.messagesController = messagesController
        loginController.plannerController = plannerController
        plannerController!.clearView()
        loginController.profileController = self
        tabBarController?.selectedIndex = 1
        present(loginController, animated: true, completion: nil)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

