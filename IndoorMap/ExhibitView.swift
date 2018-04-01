//
//  ExhibitView.swift
//  IndoorMap
//
//  Created by Shayimpagne on 31.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation
import UIKit

class ExhibitView: UIImageView, UIGestureRecognizerDelegate{
    var exhibit:Exhibit!
    
    init(frame: CGRect, exhibit: Exhibit) {
        super.init(frame: frame)
        
        self.exhibit = exhibit
        drawExhibit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawExhibit() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        tap.delegate = self
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tap)
        
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
        self.image = UIImage(named: self.exhibit.image)
        
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        print(exhibit.name)
    }
    
    
}
