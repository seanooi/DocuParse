//
//  MainCollectionViewControllerExtension.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/25/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit
import Parse
import Bolts
import SVProgressHUD
import DZNEmptyDataSet

// MARK: - UICollectionViewDelegateFlowLayout

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: sectionInset, left: sectionInset, bottom: sectionInset, right: sectionInset)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        /*
        * 2 cells per row
        * Cell padding of `sectionInset` (left, middle, right)
        */
        let width = (collectionView.frame.width - (sectionInset * 3)) / 2
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
}

// MARK: - DZNEmptyDataSetSource

extension MainCollectionViewController: DZNEmptyDataSetSource {
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "Empty")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "No Documents Found"
        let attributes = [
            NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
            NSForegroundColorAttributeName: UIColor.darkGrayColor()
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let title = "Start adding documents by tapping the '+' sign in the top right corner"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .ByWordWrapping
        paragraph.alignment = .Center;
        
        let attributes = [
            NSFontAttributeName: UIFont.systemFontOfSize(16),
            NSForegroundColorAttributeName: UIColor.darkGrayColor(),
            NSParagraphStyleAttributeName: paragraph
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        let height = view.frame.height
        
        return -(height/8)
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension MainCollectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let capturedImage = image {
            SVProgressHUD.showWithStatus("Uploading document", maskType: .Black)
            
            let imageData = UIImageJPEGRepresentation(capturedImage, 0.7)
            let imageFile = PFFile(data: imageData!)
            
            let thumbnail = self.createThumbnailForImage(capturedImage)
            let thumbnailData = UIImageJPEGRepresentation(thumbnail, 0.3)
            let thumbnailFile = PFFile(data: thumbnailData!)
            
            let docuParse = PFObject(className: documentClassName)
            docuParse["thumbnail"] = thumbnailFile
            docuParse["image"] = imageFile
            docuParse["user"] = PFUser.currentUser()
            
            docuParse.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    docuParse.pinInBackgroundWithBlock({[unowned self] (success, error) -> Void in
                        if success {
                            self.retrieveFromLocalDataStore()
                        }
                        self.showAlertWithTitle("Success!", description: "Submission successful!")
                    })
                }
                else {
                    var errorDescription = "Failed to upload document. Please try again"
                    if let saveError = error {
                        errorDescription = saveError.localizedDescription
                        
                        if saveError.code == 100 {
                            errorDescription = "Internet connection currently unavailable. Please try again later"
                        }
                    }
                    self.showAlertWithTitle("Error", description: errorDescription)
                }
            })
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    Resize a given image to 1/10th the size
    
    - parameter image: The image to be resized
    
    - returns: The resized image
    */
    func createThumbnailForImage(image: UIImage) -> UIImage {
        let size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.1, 0.1))
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        image.drawInRect(CGRect(origin: .zero, size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
}