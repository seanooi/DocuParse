//
//  DocumentCollectionViewCell.swift
//  DocuParse
//
//  Created by Sean Ooi on 6/27/15.
//  Copyright (c) 2015 Sean Ooi. All rights reserved.
//

import UIKit

class DocumentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var documentImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        documentImageView.contentMode = .ScaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        documentImageView.layer.shadowColor = UIColor.blackColor().CGColor
        documentImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
        documentImageView.layer.shadowRadius = 3
        documentImageView.layer.shadowOpacity = 0.6
        documentImageView.clipsToBounds = false
    }
}
