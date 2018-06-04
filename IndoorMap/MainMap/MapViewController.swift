//
//  MapViewController.swift
//  IndoorMap
//
//  Created by Emir Shayymov on 28.05.2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class MapViewController: UIViewController, UIScrollViewDelegate {
    var scroll:UIScrollView!
    var museumMap:MuseumMap!
    var exhibits:[Exhibit]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.title = "Map"
        
        exhibits = initExhibits()
        
        //init view
        museumMap = MuseumMap.init(frame: CGRect(x:0, y:0, width: 1100, height: 800), exhibits: exhibits) //fixed size of real room (in cm)
        museumMap.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        scroll.contentSize = museumMap.frame.size
        scroll.delegate = self
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 5.0
        scroll.zoomScale = 0.5
        scroll.addSubview(museumMap)
        
        museumMap.getMap().printMap()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.museumMap
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
