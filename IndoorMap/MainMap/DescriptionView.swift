//
//  DescriptionView.swift
//  IndoorMap
//
//  Created by Shayimpagne on 03/04/2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation
import UIKit

class DescriptionView: UIView {
    var exhibit:Exhibit!
    var text:UITextView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.exhibit = Exhibit.init(id: 11, name: "", "" ,image: "", description: "", (0, 0))
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize() {
        self.backgroundColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        
        text = UITextView()
        //text.isUserInteractionEnabled = false
        text.isScrollEnabled = true
        text.textColor = UIColor.white
        text.backgroundColor = UIColor(red: 205/255.0, green: 205/255.0, blue: 227/255.0, alpha: 1)
        text.text = exhibit.description
        self.addSubview(text)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        let textTop = NSLayoutConstraint(item: text, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let textLeading = NSLayoutConstraint(item: text, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let textTrailing = NSLayoutConstraint(item: text, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let textBottom = NSLayoutConstraint(item: text, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([textTop, textLeading, textTrailing, textBottom])
        
        
    }
    
    func setExhibit(exhibit: Exhibit) {
        self.exhibit = exhibit
        self.text.text = exhibit.description
    }
    
}
