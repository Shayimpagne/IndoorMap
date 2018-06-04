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
    var button:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.exhibit = Exhibit.init(id: 11, name: "Mikelangelo", image: "mikelangelo", description: "Mona Lisa was writing by famous Leonardo Da Vinci")
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
        
        button = UIButton()
        button.tintColor = UIColor.black
        button.setTitle("Location", for: .normal)
        button.addTarget(self, action: #selector(locationPressed), for: .touchUpInside)
        self.addSubview(button)
        
        text.translatesAutoresizingMaskIntoConstraints = false
        let textTop = NSLayoutConstraint(item: text, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let textLeading = NSLayoutConstraint(item: text, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let textTrailing = NSLayoutConstraint(item: text, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let textBottom = NSLayoutConstraint(item: text, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -44)
        
        self.addConstraints([textTop, textLeading, textTrailing, textBottom])
        
        button.translatesAutoresizingMaskIntoConstraints = false
        let heightButton = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        let buttonLeading = NSLayoutConstraint(item: button, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        let buttonTrailing = NSLayoutConstraint(item: button, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
        let buttonBottom = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        
        self.addConstraints([heightButton, buttonLeading, buttonTrailing, buttonBottom])
        
    }
    
    func setExhibit(exhibit: Exhibit) {
        self.exhibit = exhibit
        self.text.text = exhibit.description
    }
    
    @objc func locationPressed(){
        print("tapped \(exhibit.name)")
    }
    
}
