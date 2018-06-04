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
        self.map = Array2D.init(columns: 16, rows: 14, initialValue: 1) //default array
        self.exhibits = exhibits
        self.map = readMapFromFile()
    }
    
    func readMapFromFile() -> Array2D<Any> {
        var result:Array2D<Any>!
        
        if let path = Bundle.main.path(forResource: "map", ofType: "txt") {
            do {
                let file = URL(fileURLWithPath: path)
                let content = try String(contentsOf: file, encoding: .utf8)
                var columnsArray = content.components(separatedBy: "\n")
                var rowsArray = columnsArray[0].components(separatedBy: " ")
                result = Array2D.init(columns: columnsArray.count - 1, rows: rowsArray.count, initialValue: 0)
                
                for i in 0..<columnsArray.count - 1{
                    rowsArray = columnsArray[i].components(separatedBy: " ")
                    
                    for j in 0..<rowsArray.count {
                        result[i, j] = Int(rowsArray[j])!
                    }
                }
            } catch {
                print("error reading content")
            }
        }
        
        return result
    }
    
    func getExhibit(id: Int) -> Exhibit? {
        for exhibit in exhibits {
            if exhibit.id == id {
                return exhibit
            }
        }
        
        return nil
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
