//
//  AlertExtensions.swift
//  StrideLearningApp
//
//  Created by Jordan Denning on 2/11/20.
//  Copyright © 2020 Jordan Denning. All rights reserved.
//

import UIKit
import Firebase

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "The email is already in use with another account"
        case .userNotFound:
            return "Account not found for the specified user. Please check and try again"
        case .userDisabled:
            return "Your account has been disabled. Please contact support."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Please enter a valid email"
        case .networkError:
            return "Network error. Please try again."
        case .weakPassword:
            return "Invalid password. Password must have at least 6 characters, one letter, and one special character."
        case .wrongPassword:
            return "Your password is incorrect. Please try again or use 'Forgot password' to reset your password"
        case .tooManyRequests:
            return "Too many unsuccesssful login attempts. Please try again later."
        case .invalidCredential:
            return "Invalid Credential. Please check your email and password."
        case .userMismatch:
            return "Attempt to reauthenticate with a user that is not the current user. Please try again with current user."
        case .operationNotAllowed:
            return "This operation is not enable for your account. Please contact support"
        case .requiresRecentLogin:
            return "This event requires recent login. Please logout, login, and try again."
        default:
            return "Unknown error occurred"
        }
    }
}


extension UIViewController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode(rawValue: error._code) {
            print(errorCode.errorMessage)
            let alert = UIAlertController(title: "Error", message: errorCode.errorMessage, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
}
