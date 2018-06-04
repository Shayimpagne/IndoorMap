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
    override func viewDidLoad() {
        super.scroll = mapScroll
        super.viewDidLoad()
        
        self.mapScroll.setContentOffset(CGPoint(x: location.0, y: location.1), animated: true)
        
        // Do any additional setup after loading the view.
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
