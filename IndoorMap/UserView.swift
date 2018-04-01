//
//  UserView.swift
//  IndoorMap
//
//  Created by Shayimpagne on 01.04.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation
import UIKit

class UserView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        drawExhibit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawExhibit() {
        self.layer.borderWidth = 1
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
        self.image = UIImage(named: "arrow")
        self.transform = self.transform.rotated(by: CGFloat(M_PI_2 / 2))
        
        
    }
}
