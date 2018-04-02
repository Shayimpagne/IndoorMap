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
                if ((museum.map[i, j] as! Int) != 1) && ((museum.map[i, j] as! Int) != 0) {
                    view = ExhibitView.init(frame: CGRect(x: j*50, y: i*50, width: 50, height: 50), exhibit: museum.getExhibit(id: museum.map[i, j] as! Int)!)
                    self.addSubview(view)
                } else if ((museum.map[i, j] as! Int) == 1) {
                    //floor
                } else if ((museum.map[i, j] as! Int) == 0) {
                    view = UIView.init(frame: CGRect(x: j*50, y: i*50, width: 50, height: 50))
                    view.backgroundColor = UIColor.lightGray
                    self.addSubview(view)
                }
            }
        }
        
        userView = UserView.init(frame: CGRect(x: 16*50, y: 12*50, width: 50, height: 50))
        self.addSubview(userView)
        
    }
}
