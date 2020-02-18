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
        
        view.backgroundColor = .white
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
        view.backgroundColor = UIColor(r: 16, g: 153, b: 255)
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
        imageView.layer.cornerRadius = 75
        //half of 150 which is height and width
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let userName: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = label.font.withSize(20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()

    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    let firstName: UILabel = {
        let label = UILabel()
        label.text = "First Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lastName: UILabel = {
        let label = UILabel()
        label.text = "Last Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let lastNameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
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
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.setTitle("Edit Profile", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        return button
    }()
    
    lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(r: 16, g: 153, b: 255)
        button.setTitle("Change Password", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        
        button.addTarget(self, action: #selector(editPassword), for: .touchUpInside)
        
        return button
    }()
    


    func setupProfileImageView(_ user: User) {
        imageandNameView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageandNameView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageandNameView.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -20).isActive = true
        imageandNameView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //imageandNameView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        //need x, y, width, height constraints
        imageandNameView.addSubview(profileImageView)
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }

        profileImageView.centerXAnchor.constraint(equalTo: imageandNameView.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: imageandNameView.centerYAnchor, constant: 20).isActive = true
        //profileImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true

    
        imageandNameView.addSubview(userName)
        userName.text = user.name
    
        userName.centerXAnchor.constraint(equalTo: imageandNameView.centerXAnchor).isActive = true
        userName.bottomAnchor.constraint(equalTo: imageandNameView.bottomAnchor, constant: -20).isActive = true
    }
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var firstNameLabelHeightAnchor: NSLayoutConstraint?
    var firstNameTextFieldHeightAnchor: NSLayoutConstraint?
    var lastNameTextFieldHeightAnchor: NSLayoutConstraint?
    var lastNameLabelHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var emailLabelHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordConfirmTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputsContainerView(_ user: User) {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.topAnchor.constraint(equalTo: imageandNameView.bottomAnchor, constant: 40).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 180)
        inputsContainerViewHeightAnchor?.isActive = true


        firstName.text = user.firstName
        lastName.text = user.lastName
        email.text = user.email
        
        
        inputsContainerView.addSubview(firstNameLabel)
        inputsContainerView.addSubview(firstName)
        inputsContainerView.addSubview(firstNameSeparatorView)
        inputsContainerView.addSubview(lastNameLabel)
        inputsContainerView.addSubview(lastName)
        inputsContainerView.addSubview(lastNameSeparatorView)
        inputsContainerView.addSubview(emailLabel)
        inputsContainerView.addSubview(email)
        inputsContainerView.addSubview(emailSeparatorView)
        
        //First Name Label
        firstNameLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        firstNameLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 100).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        
        firstNameLabelHeightAnchor = firstNameLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        firstNameLabelHeightAnchor?.isActive = true
        
        //First Name
        firstName.leftAnchor.constraint(equalTo: firstNameLabel.rightAnchor, constant: 12).isActive = true
        firstName.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        firstName.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        firstNameTextFieldHeightAnchor = firstName.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        firstNameTextFieldHeightAnchor?.isActive = true
        
        //Firt Name Separator View
        firstNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        firstNameSeparatorView.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        firstNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        firstNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Last Name Label
        lastNameLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        lastNameLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 100).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor).isActive = true
        
        lastNameLabelHeightAnchor = lastNameLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        lastNameLabelHeightAnchor?.isActive = true
        
        //Last Name
        lastName.leftAnchor.constraint(equalTo: lastNameLabel.rightAnchor, constant: 12).isActive = true
        lastName.topAnchor.constraint(equalTo: firstNameSeparatorView.bottomAnchor).isActive = true
        lastName.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        
        lastNameTextFieldHeightAnchor = lastName.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        lastNameTextFieldHeightAnchor?.isActive = true
        
        //Last Name Separator View
        lastNameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        lastNameSeparatorView.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor).isActive = true
        lastNameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        lastNameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //Email Label
        emailLabel.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailLabel.rightAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 100).isActive = true
        emailLabel.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor).isActive = true
        
        emailLabelHeightAnchor = emailLabel.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        emailLabelHeightAnchor?.isActive = true
        
        //Email
        email.leftAnchor.constraint(equalTo: emailLabel.rightAnchor, constant: 12).isActive = true
        email.topAnchor.constraint(equalTo: lastNameSeparatorView.bottomAnchor).isActive = true
        
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
        buttonsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        buttonsContainerView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        
        buttonsContainerView.addSubview(editProfileButton)
        buttonsContainerView.addSubview(changePasswordButton)
        
        editProfileButton.centerXAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 175).isActive = true
        
        changePasswordButton.centerXAnchor.constraint(equalTo: buttonsContainerView.centerXAnchor).isActive = true
        changePasswordButton.topAnchor.constraint(equalTo:
            editProfileButton.bottomAnchor, constant: 20).isActive = true
        changePasswordButton.widthAnchor.constraint(equalToConstant: 175).isActive = true
        
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
                self.firstName.text = user.firstName
                self.lastName.text = user.lastName
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



