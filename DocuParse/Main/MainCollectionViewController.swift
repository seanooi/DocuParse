//
//  MainCollectionViewController.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/25/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit
import MobileCoreServices
import Parse
import Bolts
import DZNEmptyDataSet
import SVProgressHUD

let documentClassName = "DocuParseDocs"

class MainCollectionViewController: UICollectionViewController {
    
    let reuseIdentifier = "Cell"
    let sectionInset: CGFloat = 16
    
    var fullImageDataArray = [NSData]()
    var thumbnailImageDataArray = [NSData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Documents"
        collectionView?.backgroundColor = UIColor.colorWithHex("ecf0f1")
        collectionView?.emptyDataSetSource = self
        
        retrieveFromLocalDataStore()
        syncLocalDatastore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbnailImageDataArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let imageData = thumbnailImageDataArray[indexPath.item]
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DocumentCollectionViewCell
        cell.documentImageView.image = UIImage(data: imageData)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedObject = fullImageDataArray[indexPath.item]
        performSegueWithIdentifier("showImage", sender: selectedObject)
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImage" {
            let selectedObject = sender as! NSData
            let destination = segue.destinationViewController as! DocumentViewController
            destination.selectedImage = UIImage(data: selectedObject)
        }
    }
    
    // MARK: - Local datastore
    
    /**
    Retrieve records from the local datastore for offline usage
    */
    func retrieveFromLocalDataStore() {
        let query = PFQuery(className: documentClassName)
        query.fromLocalDatastore()
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {[unowned self] (responseObject, error) -> Void in
            if error == nil {
                if let queryArray = responseObject as [PFObject]! {
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        /*
                        * Copy array in loop because Parse uses `NSArray` type
                        * Only copy items that are not in `objectArray`
                        */
                        for obj in queryArray {
                            if let image = obj.objectForKey("image") as? PFFile {
                                do {
                                    let imageData = try image.getData()
                                    if !self.fullImageDataArray.contains(imageData) {
                                        self.fullImageDataArray.insert(imageData, atIndex: 0)
                                    }
                                }
                                catch {
                                    print("Image get data error")
                                }
                            }
                            
                            if let thumbnail = obj.objectForKey("thumbnail") as? PFFile {
                                do {
                                    let thumbnailData = try thumbnail.getData()
                                    if !self.thumbnailImageDataArray.contains(thumbnailData) {
                                        self.thumbnailImageDataArray.insert(thumbnailData, atIndex: 0)
                                    }
                                }
                                catch {
                                    print("Thumbnail get data error")
                                }
                            }
                        }
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            self.collectionView?.reloadData()
                        }
                    }
                }
            }
            else {
                let errorDescription = error?.localizedDescription ?? "Failed to retrieve records"
                self.showAlertWithTitle("Query Error", description: errorDescription)
            }
        }
    }
    
    /**
    Keep records in sync across every device signed in with the same account
    Also a good point to check for valid session tokens
    */
    func syncLocalDatastore() {
        let query = PFQuery(className: documentClassName)
        query.findObjectsInBackgroundWithBlock { (responseObject, error) -> Void in
            if error == nil {
                if let documents = responseObject as [PFObject]! {
                    PFObject.pinAllInBackground(documents, block: {[unowned self] (success, error) -> Void in
                        if success {
                            self.retrieveFromLocalDataStore()
                        }
                        else {
                            let errorDescription = error?.localizedDescription ?? "Unable to sync local datastore"
                            self.showAlertWithTitle("Query Error", description: errorDescription)
                        }
                    })
                }
            }
            else {
                if let errorCode = error?.code where errorCode == 209 {
                    let storyboard = UIStoryboard(name: "Login", bundle: nil)
                    let controller = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") 
                    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.window?.rootViewController = controller
                    
                    let alertController = UIAlertController(title: "Invalid Session", message: "Session token has expired. Please login again.", preferredStyle: .Alert)
                    
                    let dismiss = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(dismiss)
                    
                    controller.presentViewController(alertController, animated: true, completion: nil)
                }
                else {
                    let errorDescription = error?.localizedDescription ?? "Unable to sync local datastore"
                    self.showAlertWithTitle("Query Error", description: errorDescription)
                }
            }
        }
    }
    
    // MARK: - Validation
    
    func hasRearCamera() -> Bool {
        return UIImagePickerController.isCameraDeviceAvailable(.Rear)
    }
    
    func hasImageSupport() -> Bool {
        if let
            types = UIImagePickerController.availableMediaTypesForSourceType(.Camera) where
            types.contains((kUTTypeImage as String))
        {
            return true
        }
        
        return false
    }
    
    // MARK: - IBActions
    
    @IBAction func showCamera() {
        if hasRearCamera() && hasImageSupport() {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .Camera
            pickerController.mediaTypes = [kUTTypeImage as String]
            pickerController.allowsEditing = false
            
            presentViewController(pickerController, animated: true, completion: nil)
        }
        else {
            showAlertWithTitle("No Camera", description: "The current device does not have a camera.")
        }
    }
    
    @IBAction func logout() {
        PFUser.logOutInBackgroundWithBlock {[unowned self] (error) -> Void in
            if error == nil {
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let contentController = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") 
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.window?.rootViewController = contentController
            }
            else {
                self.showAlertWithTitle("Logout Error", description: "Something happened while trying to logout. Please try again.")
            }
        }
    }
    
    // MARK: - UIAlertController
    
    func showAlertWithTitle(title: String, description: String) {
        SVProgressHUD.dismiss()
        
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .Alert)
        
        let dismiss = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alertController.addAction(dismiss)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
