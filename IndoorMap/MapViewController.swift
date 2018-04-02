//
//  MapViewController.swift
//  IndoorMap
//
//  Created by Shayimpagne on 31.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scroll:UIScrollView!
    var museumMap:MuseumMap!
    var exhibits:[Exhibit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray //UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        self.title = "Map"
        
        exhibits.append(Exhibit.init(id: 2, name: "Mona lisa", image: "monalisa"))
        exhibits.append(Exhibit.init(id: 3, name: "Gustav Klimt", image: "kiss"))
        exhibits.append(Exhibit.init(id: 4, name: "Mone", image: "mone"))
        exhibits.append(Exhibit.init(id: 5, name: "Scream", image: "scream"))
        exhibits.append(Exhibit.init(id: 6, name: "Van Gogh", image: "night"))
        exhibits.append(Exhibit.init(id: 7, name: "Picasso Guernica", image: "guernica"))
        exhibits.append(Exhibit.init(id: 8, name: "Van Gogh Night Cafe", image: "night_cafe"))
        exhibits.append(Exhibit.init(id: 9, name: "Salvador Dali Time", image: "dali_time"))
        exhibits.append(Exhibit.init(id: 10, name: "Rembrant Night", image: "rembrant_night"))
        exhibits.append(Exhibit.init(id: 11, name: "Mikelangelo", image: "mikelangelo"))
        
        museumMap = MuseumMap.init(frame: CGRect(x:0, y:0, width: 1100, height: 800), exhibits: exhibits) //fixed size of real indoor (in cm)
        museumMap.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        scroll.contentSize = museumMap.frame.size
        scroll.delegate = self
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 5.0
        
        scroll.addSubview(museumMap)
        
        museumMap.getMap().printMap()
        
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
