//
//  MuseumMap.swift
//  IndoorMap
//
//  Created by Shayimpagne on 30.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation
import UIKit

class MuseumMap: UIView {
    var museum:MatrixMap!
    var color:UIColor!
    var view:UIView!
    var exhibitView:ExhibitView!
    var exhibitArray:[ExhibitView] = []
    var userView:UIView!
    
    init(frame: CGRect, exhibits: [Exhibit]) {
        super.init(frame: frame)
        
        museum = MatrixMap.init(exhibits: exhibits)
        drawMap()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func getMap() -> MatrixMap {
        return museum
    }
    
    func drawMap() {
        self.backgroundColor = UIColor.lightGray
        
        for i in 0..<museum.map.columns {
            for j in 0..<museum.map.rows {
                if ((museum.map[i, j] as! Int) == 1) {
                    //floor
                } else if ((museum.map[i, j] as! Int) == 0) {
                    view = UIView.init(frame: CGRect(x: j*50, y: i*50, width: 50, height: 50))
                    view.backgroundColor = UIColor.lightGray
                    self.addSubview(view)
                }
            }
        }
        
        for i in 0..<museum.map.columns {
            for j in 0..<museum.map.rows {
                if ((museum.map[i, j] as! Int) != 1) && ((museum.map[i, j] as! Int) != 0) {
                    exhibitView = ExhibitView.init(frame: CGRect(x: j*50, y: i*50, width: 50, height: 50), exhibit: museum.getExhibit(id: museum.map[i, j] as! Int)!)
                    museum.getExhibit(id: museum.map[i, j] as! Int)?.setLocation(location: (j*50, i*50))
                    self.exhibitArray.append(exhibitView)
                    self.addSubview(exhibitArray.last!)
                }
            }
        }
        
        userView = UserView.init(frame: CGRect(x: -50, y: -50, width: 50, height: 50))
        self.addSubview(userView)
        
    }
    
    func changeUserLocation(x: Double, y: Double) {
        userView.removeFromSuperview()
        userView = UserView.init(frame: CGRect(x: Int(x) * 50, y: Int(y) * 50, width: 50, height: 50))
        self.addSubview(userView)
    }
    
    func getExhibitViewByID(id: Int) -> ExhibitView? {
        for ex in exhibitArray {
            if ex.exhibit.id == id {
                return ex
            }
        }
        
        return nil
    }
}
