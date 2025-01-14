//
//  ServerError.swift
//  AirQualityDemo
//
//  Created by AndyHsieh on 2025/1/2.
//

import Foundation

/// 將後台回傳的錯誤字樣轉成包含多國語言的錯誤
enum ServerError: String, LocalizedError {
    case accountUnauthorized = "Unauthorised"
    case accountNotActivated = "The account is not activated"
    case accountAlreadyRegistered = "Account already exists"
    case insufficientParameters = "Necessary parameters are wrong"
    case dataNotFound = "Data could not find"
    case invalidEmail = "The email must be a valid email address."
    case accountNotFound = "No this account"
    case accountAlreadyActivated = "The account is activated"
    case passwordError = "Password error"
    case mailError = "mail error"
    
    var errorDescription: String? {
        switch self {
        case .accountUnauthorized:
            return NSLocalizedString("text_label_login_incorrect_email_or_password", comment: "")
        case .accountNotActivated:
            return NSLocalizedString("text_message_error_email_unregistered", comment: "")
        case .insufficientParameters:
            return NSLocalizedString("text_message_error_parameters_insufficient", comment: "")
        case .dataNotFound:
            return NSLocalizedString("text_message_error_data_not_found", comment: "")
        case .invalidEmail:
            return NSLocalizedString("text_label_email_invalid", comment: "")
        case .accountAlreadyRegistered:
            return NSLocalizedString("text_message_error_email_already_registered", comment: "")
        case .accountNotFound:
            return NSLocalizedString("text_label_no_this_account", comment: "")
        case .accountAlreadyActivated:
            return NSLocalizedString("text_label_account_is_activated", comment: "")
        case .passwordError:
            return NSLocalizedString("text_message_error_password_change_invalid", comment: "")
        case .mailError:
            return NSLocalizedString("text_label_no_this_account", comment: "")
        }
        
    }
}

