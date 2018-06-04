//
//  Constants.swift
//  IndoorMap
//
//  Created by Shayimpagne on 18/04/2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation

class Guide {
    var id:Int!
    var location:(Double, Double)!
    var description:String!
    var guides:[Guide] = []
    
    init(_ id: Int, _ location: (Double, Double), _ description: String) {
        self.id = id
        self.location = location
        self.description = description
    }
    
}
