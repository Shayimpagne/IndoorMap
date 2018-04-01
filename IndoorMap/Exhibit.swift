//
//  Exhibit.swift
//  IndoorMap
//
//  Created by Shayimpagne on 30.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation

enum Side {
    case left
    case right
    case top
    case bottom
}

class Exhibit {
    var id:Int
    var name:String
    var image:String
    var location:(Side, Int)
    
    init(id: Int, name:String, image: String, location: (Side, Int)) {
        self.id = id
        self.name = name
        self.image = image
        self.location = location
    }
    
}
