//
//  CameraMapViewController.swift
//  IndoorMap
//
//  Created by Emir Shayymov on 28.05.2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit

class CameraMapViewController: MapViewController {
    @IBOutlet var mapScroll:UIScrollView!
    var location:(Int, Int)!
    var currentExhibitName:String!
    override func viewDidLoad() {
        super.scroll = mapScroll
        super.viewDidLoad()
        
        for exhibit in museumMap.exhibitArray {
            if exhibit.exhibit.name.lowercased() == currentExhibitName.lowercased() {
                self.scroll.scrollRectToVisible(CGRect(x: exhibit.exhibit.getLocation().0, y: exhibit.exhibit.getLocation().1, width: 1, height: 1), animated: true)
                exhibit.handleTap()
                break
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
