//
//  Constants.swift
//  IndoorMap
//
//  Created by Shayimpagne on 18/04/2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation

class Constants {
    var id:Int!
    var immediateLocation:(Int, Int)!
    var nearLocation:(Int, Int)!
    var description:String!
    
    init(_ id: Int, _ immediateLocation: (Int, Int), _ nearLocation: (Int, Int), _ description: String) {
        self.id = id
        self.immediateLocation = immediateLocation
        self.nearLocation = nearLocation
        self.description = description
    }
    
}
