//
//  DocumentViewControllerExtension.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/28/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

extension DocumentViewController: UIScrollViewDelegate {
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        updateConstraints()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}