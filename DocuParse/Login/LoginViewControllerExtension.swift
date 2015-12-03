//
//  LoginViewControllerExtension.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/28/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
            
        case passwordTextField:
            validate()
            
        default:
            textField.resignFirstResponder()
        }
        
        return true
    }
    
}