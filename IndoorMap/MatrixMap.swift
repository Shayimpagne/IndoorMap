//
//  MatrixMap.swift
//  IndoorMap
//
//  Created by Shayimpagne on 31.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation

class MatrixMap {
    var map:Array2D<Any>
    var exhibits:[Exhibit]
    
    init(exhibits: [Exhibit]) {
        //map of 14x16 (50cm x 50cm) room 7mx8m
        self.map = Array2D.init(columns: 16, rows: 14, initialValue: 0)
        self.exhibits = exhibits
        
        initMap()
    }
    
    func metersToCell(meter: Int) -> Int {
        return 2*meter
    }
    
    func getExhibit(id: Int) -> Exhibit? {
        for exhibit in exhibits {
            if exhibit.id == id {
                return exhibit
            }
        }
        
        return nil
    }
    
    func initMap() {
        for exhibit in exhibits {
            switch exhibit.location.0 {
            case Side.left:
                map[exhibit.location.1, 0] = exhibit.id
                continue
            case Side.right:
                map[exhibit.location.1, map.rows - 1] = exhibit.id
                continue
            case Side.top:
                map[0, exhibit.location.1] = exhibit.id
                continue
            case Side.bottom:
                map[map.columns - 1, exhibit.location.1] = exhibit.id
                continue
            }
            
        }
    }
    
    func printMap() {
        for i in 0..<map.columns {
            for j in 0..<map.rows {
                print(map[i, j], terminator: " ")
            }
            print()
        }
    }
}
