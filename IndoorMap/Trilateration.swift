//
//  Trilateration.swift
//  TestURL
//
//  Created by Shayimpagne on 06/04/2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import Foundation

class Trilateration {
    var  x1, x2, x3, y1, y2, y3, accur1, accur2, accur3:Double
    
    init(x1: Double, y1: Double, accur1: Double, x2: Double, y2: Double, accur2:Double, x3: Double, y3: Double, accur3:Double) {
        self.x1 = x1
        self.x2 = x2
        self.x3 = x3
        self.y1 = y1
        self.y2 = y2
        self.y3 = y3
        self.accur1 = accur1
        self.accur2 = accur2
        self.accur3 = accur3
    }
    
    func changeValues(x1: Double, y1: Double, accur1: Double, x2: Double, y2: Double, accur2: Double, x3: Double, y3: Double, accur3: Double) {
        self.x1 = x1
        self.x2 = x2
        self.x3 = x3
        self.y1 = y1
        self.y2 = y2
        self.y3 = y3
        self.accur1 = accur1
        self.accur2 = accur2
        self.accur3 = accur3
    }
    
    func trilaterate() -> (Double, Double) {
        var P1 = [x1, y1, 0]
        var P2 = [x2, y2, 0]
        var P3 = [x3, y3, 0]
        
        var ex:[Double] = [0, 0, 0]
        var P2P1:Double = 0
        
        for i in 0..<3 {
            P2P1 += pow(P2[i] - P1[i], 2)
        }
        
        for i in 0..<3 {
            ex[i] = (P2[i] - P1[i]) / P2P1.squareRoot()
        }
        
        var P3P1:[Double] = [0, 0, 0]
        
        for i in 0..<3 {
            P3P1[i] = P3[i] - P1[i]
        }
        
        var ivar:Double = 0
        
        for i in 0..<3 {
            ivar += (ex[i] * P3P1[i])
        }
        
        var P3P1i:Double = 0
        
        for i in 0..<3 {
            P3P1i += pow(P3[i] - P1[i] - ex[i] * ivar, 2)
        }
        
        var ey:[Double] = [0, 0, 0]
        
        for i in 0..<3 {
            ey[i] = (P3[i] - P1[i] - ex[i] * ivar / P3P1i.squareRoot())
        }
        
        var ez:[Double] = [0, 0, 0]
        let d:Double = P2P1.squareRoot()
        var jvar:Double = 0
        
        for i in 0..<3 {
            jvar += (ey[i] * P3P1[i])
        }
        
        let x:Double = (pow(accur1, 2) - pow(accur2, 2) + pow(d, 2)) / (2 * d)
        let y:Double = ((pow(accur1, 2) - pow(accur3, 2) + pow(ivar, 2) + pow(jvar, 2)) / (2 * jvar)) - ((ivar / jvar) * x)
        
        var z:Double = sqrt(pow(accur1, 2) - pow(x, 2) - pow(y, 2))
        if z.isNaN {
            z = 0
        }
        
        var triPt:[Double] = [0, 0, 0]
        
        for i in 0..<3 {
            var temp:Double = P1[i] + (ex[i] * x)
            temp += (ey[i] * y) + (ez[i] * z)
            triPt[i] = temp
        }
        
        return (triPt[0], triPt[1])
    }
}
