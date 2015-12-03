//
//  Util.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/26/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

extension UIColor {
    /**
    Creates a color from the given hex color code.
    If an invalid hex is given, default returned color is black color.
    
    - parameter hex: The hex code of the color to be created. (# sign is optional)
    - parameter alpha: The opacity of the color. Default value is 1
    
    - returns: The `UIColor` object
    */
    public class func colorWithHex(hex: String, alpha: CGFloat = 1) -> UIColor {
        if hex.characters.count > 7 ||
            hex.isEmpty ||
            (hex.characters.count == 7 && !hex.hasPrefix("#"))
        {
            return UIColor.blackColor()
        }
        
        var rgb: CUnsignedInt = 0
        let scanner = NSScanner(string: hex)
        
        if hex.hasPrefix("#") {
            // skip '#' character
            scanner.scanLocation = 1
        }
        
        scanner.scanHexInt(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0xFF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension String {
    /**
    MD5 hash generator
    
    - returns: The generated MD5 hash from the given string
    */
    public func md5() -> String {
        let data = (self as NSString).dataUsingEncoding(NSUTF8StringEncoding)!
        let result = NSMutableData(length: Int(CC_MD5_DIGEST_LENGTH))!
        let resultBytes = UnsafeMutablePointer<CUnsignedChar>(result.mutableBytes)
        CC_MD5(data.bytes, CC_LONG(data.length), resultBytes)
        
        let a = UnsafeBufferPointer<CUnsignedChar>(start: resultBytes, count: result.length)
        let hash = NSMutableString()
        
        for i in a {
            hash.appendFormat("%02x", i)
        }
        
        return hash as String
    }
}