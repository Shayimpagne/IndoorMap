//
//  UserView.swift
//  IndoorMap
//
//  Created by Shayimpagne on 01.04.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation
import UIKit

class UserView: UIImageView, UIGestureRecognizerDelegate {
    var x:Int!
    var y:Int!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        x = 0
        y = 0
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
        
        self.image = UIImage(named: "arrow")
        self.transform = self.transform.rotated(by: CGFloat(Double.pi / 4))
        
        
    }
    
    func userLocation(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    func getLocation() -> (Int, Int) {
        return (self.x, self.y)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        //userLocation(x: self.x + 1, y: self.y + 1)
        
    }
    
}
