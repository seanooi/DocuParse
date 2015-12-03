//
//  DocumentViewController.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/28/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    
    var currentViewSize: CGSize!
    var lastZoomScale: CGFloat = -1
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Preview"
        view.backgroundColor = .blackColor()
        
        currentViewSize = view.bounds.size
        imageView.image = selectedImage
        scrollView.delegate = self
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        
        updateZoom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        currentViewSize = size
        updateZoom()
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.locationInView(imageView)
        let newZoomScale = scrollView.zoomScale != scrollView.maximumZoomScale ? scrollView.maximumZoomScale : scrollView.minimumZoomScale
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func updateConstraints() {
        if let image = imageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            
            let viewWidth = currentViewSize.width
            let viewHeight = currentViewSize.height
            
            // center image if it is smaller than screen
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 {
                hPadding = 0
            }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 3
            if vPadding < 0 {
                vPadding = 0
            }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            // Makes zoom out animation smooth and starting from the right point not from (0, 0)
            view.layoutIfNeeded()
        }
    }
    
    func updateZoom() {
        if let image = imageView.image {
            var minZoom = min(currentViewSize.width / image.size.width, currentViewSize.height / image.size.height)
            
            if minZoom > 1 {
                minZoom = 1
            }
            
            scrollView.minimumZoomScale = minZoom
            
            // Force scrollViewDidZoom fire if zoom did not change)
            if minZoom == lastZoomScale {
                minZoom += 0.000001
            }
            
            scrollView.zoomScale = minZoom
            lastZoomScale = minZoom
        }
    }

}
