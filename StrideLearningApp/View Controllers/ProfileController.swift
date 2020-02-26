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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(r: 245, g:245, b:245)
        view.addSubview(imageandNameView)
        view.addSubview(inputsContainerView)
        view.addSubview(buttonsContainerView)
        
        fetchUserAndSetupProfile()
        setupButtonView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Profile"
        self.tabBarController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        
        updateData()
    }
    

    let imageandNameView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //view.backgroundColor = UIColor(r:16, g:153, b:255)
        view.layer.cornerRadius = 10
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
//        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor(r:16, g:153, b:255).cgColor
        imageView.layer.cornerRadius = 70
        //half of 140 which is height and width
        imageView.clipsToBounds = true
        
        if UIScreen.main.sizeType == .iPhone5 {
            // decrease size of profile picture
            imageView.layer.cornerRadius = 50
        }
        
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let inputsContainerView: UIView = {
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
        //view.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = false
        
        return view
    }()
    
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Edit Profile", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 16, g: 153, b: 255), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 5
        
        //border
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 16, g: 153, b: 255).cgColor
        
        //drop shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 3
        
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        return button
    }()
    
    lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Change Password", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(r: 16, g: 153, b: 255), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        button.layer.cornerRadius = 5
        
        //border
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor(r: 16, g: 153, b: 255).cgColor
        
        //drop shadow
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowOffset = .zero
        button.layer.shadowRadius = 3
        
        button.addTarget(self, action: #selector(editPassword), for: .touchUpInside)
        
        return button
    }()
    
    
    func setupProfileImageView(_ user: User) {
        imageandNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageandNameView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageandNameView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        imageandNameView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 2/5).isActive = true
        
        //need x, y, width, height constraints
        imageandNameView.addSubview(profileImageView)
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }

        profileImageView.centerXAnchor.constraint(equalTo: imageandNameView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: imageandNameView.centerYAnchor, constant: 20).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        if UIScreen.main.sizeType == .iPhone5 {
            // decrease size of profile picture
            profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
            profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            
        }

    
        imageandNameView.addSubview(userName)
        userName.text = user.name
    
        userName.centerXAnchor.constraint(equalTo: imageandNameView.centerXAnchor).isActive = true
        userName.bottomAnchor.constraint(equalTo: imageandNameView.bottomAnchor, constant: -10).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var gradeLabelHeightAnchor: NSLayoutConstraint?
    var gradeTextFieldHeightAnchor: NSLayoutConstraint?
    var schoolTextFieldHeightAnchor: NSLayoutConstraint?
    var schoolLabelHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var emailLabelHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordConfirmTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView(_ user: User) {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: imageandNameView.bottomAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 180)
        inputsContainerViewHeightAnchor?.isActive = true


        grade.text = user.grade
        school.text = user.school
        email.text = user.email
        
        
        inputsContainerView.addSubview(gradeLabel)
        inputsContainerView.addSubview(grade)
        inputsContainerView.addSubview(gradeSeparatorView)
        inputsContainerView.addSubview(schoolLabel)
        inputsContainerView.addSubview(school)
        inputsContainerView.addSubview(schoolSeparatorView)
        inputsContainerView.addSubview(emailLabel)
        inputsContainerView.addSubview(email)
        inputsContainerView.addSubview(emailSeparatorView)
        
        //First Name Label
        gradeLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 18).isActive = true
        gradeLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 100).isActive = true
        gradeLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        gradeLabelHeightAnchor = gradeLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        gradeLabelHeightAnchor?.isActive = true
        
        //First Name
        grade.leftAnchor.constraint(equalTo: gradeLabel.rightAnchor, constant: 8).isActive = true
        grade.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        grade.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        gradeTextFieldHeightAnchor = grade.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        gradeTextFieldHeightAnchor?.isActive = true
        
        //Firt Name Separator View
        gradeSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        gradeSeparatorView.topAnchor.constraint(equalTo: gradeLabel.bottomAnchor).isActive = true
        gradeSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        gradeSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Last Name Label
        schoolLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 18).isActive = true
        schoolLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 100).isActive = true
        schoolLabel.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor).isActive = true
        
        schoolLabelHeightAnchor = schoolLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        schoolLabelHeightAnchor?.isActive = true
        
        //Last Name
        school.leftAnchor.constraint(equalTo: schoolLabel.rightAnchor, constant: 8).isActive = true
        school.topAnchor.constraint(equalTo: gradeSeparatorView.bottomAnchor).isActive = true
        school.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        schoolTextFieldHeightAnchor = school.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        schoolTextFieldHeightAnchor?.isActive = true
        
        //Last Name Separator View
        schoolSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        schoolSeparatorView.topAnchor.constraint(equalTo: schoolLabel.bottomAnchor).isActive = true
        schoolSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        schoolSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Email Label
        emailLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 18).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 100).isActive = true
        emailLabel.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor).isActive = true
        
        emailLabelHeightAnchor = emailLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailLabelHeightAnchor?.isActive = true
        
        //Email
        email.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 8).isActive = true
        email.topAnchor.constraint(equalTo: schoolSeparatorView.bottomAnchor).isActive = true
        
        email.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = email.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        //Email Separator View
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailLabel.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        


    }
    
    func setupButtonView() {
        buttonsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsContainerView.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 20).isActive = true
        buttonsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
        buttonsContainerView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        buttonsContainerView.addSubview(editProfileButton)
        buttonsContainerView.addSubview(changePasswordButton)
        
        editProfileButton.centerYAnchor.constraint(equalTo: buttonsContainerView.centerYAnchor).isActive = true
        editProfileButton.rightAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor, constant: -12).isActive = true
        editProfileButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 2/5).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        changePasswordButton.centerYAnchor.constraint(equalTo: buttonsContainerView.centerYAnchor).isActive = true
        changePasswordButton.leftAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor, constant: 12).isActive = true
        changePasswordButton.widthAnchor.constraint(equalTo: view.widthAnchor  , multiplier: 2/5).isActive = true
        changePasswordButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    
    func fetchUserAndSetupProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User(dictionary: dictionary)
                self.setupProfileImageView(user)
                self.setupInputsContainerView(user)
                
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
        //.child("profile_images") creates new child folder where these images will be stored
        
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
//        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

