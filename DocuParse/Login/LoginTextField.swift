//
//  LoginTextField.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/26/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

/**
*  Adds padding to UITextFields
*/
class LoginTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .whiteColor()
        font = UIFont.systemFontOfSize(16)
        textColor = UIColor.colorWithHex("868686")
        clearButtonMode = UITextFieldViewMode.WhileEditing
        autocorrectionType = .No
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.borderColor = UIColor.colorWithHex("#e3e3e5").CGColor
        layer.borderWidth = 1
    }
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        return newBounds(bounds)
    }
    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        return newBounds(bounds)
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return newBounds(bounds)
    }
    
    func newBounds(bounds: CGRect) -> CGRect {
        var newBounds = bounds
        newBounds.origin.x += padding.left
        newBounds.origin.y += padding.top
        newBounds.size.height -= (padding.top * 2) - padding.bottom
        newBounds.size.width -= (padding.left * 2) - padding.right
        
        return newBounds
    }

}
