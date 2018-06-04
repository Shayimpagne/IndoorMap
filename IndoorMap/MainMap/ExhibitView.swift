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
        self.tag = exhibit.id
        
        drawExhibit()
    }
    
    init() {
        super.init(frame: CGRect(x: 0, y:0, width:0, height: 0))
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
    
    func resizeExhibit() {
        self.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    func resetExhibit() {
        self.transform = CGAffineTransform.identity
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer? = nil) {
        UIView.animate(withDuration: 0.5, animations: ({
            if self.frame.size.width > 60 {
                self.resetExhibit()
            } else {
                NotificationCenter.default.post(name: Notification.Name("description"), object: nil, userInfo: ["id" : self.exhibit.id])
                self.resizeExhibit()
            }
        }))
    }
    
    func selectExhibit() {
        UIView.animate(withDuration: 0.5, animations: {
            self.resizeExhibit()
        })
    }

}
