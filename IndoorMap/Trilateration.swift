//
//  Trilateration.swift
//  TestURL
//
//  Created by Shayimpagne on 06/04/2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//  Uses trilateration algorhitm to found point in meters

import Foundation

class Trilateration {
    var  x1,x2,x3,y1,y2,y3,dist1,dist2,dist3:Double
    
    init(x1: Double, y1: Double, dist1: Double, x2: Double, y2: Double, dist2:Double, x3: Double, y3: Double, dist3:Double) {
        self.x1 = x1
        self.x2 = x2
        self.x3 = x3
        self.y1 = y1
        self.y2 = y2
        self.y3 = y3
        self.dist1 = dist1
        self.dist2 = dist2
        self.dist3 = dist3
    }
    
    func trilateration(dist1: Double, dist2: Double, dist3: Double) -> (Double, Double) {
        var P1 = [x1, y1]
        var P2 = [x2, y2]
        var P3 = [x3, y3]
        
        var ex:[Double] = [0, 0]
        var P2P1:Double = 0
        
        for i in 0..<2 {
            P2P1 += pow(P2[i] - P1[i], 2)
        }
        
        P2P1 = pow(P2P1, 0.5) // ||P2 - P1||
        
        for i in 0..<2 {
            ex[i] = (P2[i] - P1[i])/P2P1 // ex - vector
        }
        
        var ivar:Double = 0
        
        for i in 0..<2 {
            ivar += ex[i] * (P3[i] - P1[i]) // i = ex * (P3 - P1)
        }
        
        var ey:[Double] = [0, 0]
        
        let norm:Double = pow(pow(P3[0] - P1[0] - ivar*ex[0], 2) + pow(P3[1] - P1[1] - ivar*ex[1], 2), 0.5) // norm ||P3 - P1 - i * ex||
        
        for i in 0..<2 {
            ey[i] = (P3[i] - P1[i] - ivar*ex[i]) / norm // ey - vector = (P3 - P1 - i * ex) / ||P3 - P1 - i * ex||
        }
        
        var jvar:Double = 0
        for i in 0..<2 {
            jvar += ey[i] * (P3[i] - P1[i]) // j = ey * (P3 - P1)
        }
        
        let x:Double = (pow(dist1, 2) - pow(dist2, 2) + pow(P2P1, 2)) / (2 * P2P1)
        let y:Double = (pow(dist1, 2) - pow(dist3, 2) + pow(ivar, 2) + pow(jvar, 2)) / (2 * jvar) - ivar * x / jvar
        
        var point:[Double] = [0, 0]
        
        for i in 0..<2 {
            point[i] = P1[i] + x * ex[i] + y * ey[i]
        }
        
        return (point[0], point[1])
    }
    
}
