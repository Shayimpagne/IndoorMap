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
    var guideName:String!
    var image:String!
    var description:String!
    var location:(Int, Int)!
    
    init(id: Int, name:String, _ guideName: String, image: String, description: String, _ location: (Int, Int)) {
        self.id = id
        self.name = name
        self.guideName = guideName
        self.image = image
        self.description = description
        self.location = location
    }
    
    func getLocation() -> (Int, Int) {
        return self.location
    }
    
    func setLocation(location: (Int, Int)) {
        self.location = location
    }
    
}
