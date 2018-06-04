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
    var id:Int!
    var name:String!
    var image:String!
    var description:String!
    var location:(Int, Int)!
    
    init(id: Int, name:String, image: String, description: String) {
        self.id = id
        self.name = name
        self.image = image
        self.description = description
        self.location = (0, 0)
    }
    
    func getLocation() -> (Int, Int) {
        return self.location
    }
    
    func setLocation(location: (Int, Int)) {
        self.location = location
    }
    
}
