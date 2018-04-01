//
//  MapViewController.swift
//  IndoorMap
//
//  Created by Shayimpagne on 31.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    @IBOutlet var scroll:UIScrollView!
    var museumMap:MuseumMap!
    var exhibits:[Exhibit] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        exhibits.append(Exhibit.init(id: 1, name: "Mona lisa", image: "monalisa", location: (Side.left, 3)))
        exhibits.append(Exhibit.init(id: 2, name: "Gustav Klimt", image: "kiss", location: (Side.left, 5)))
        exhibits.append(Exhibit.init(id: 3, name: "Mone", image: "mone", location: (Side.bottom, 1)))
        exhibits.append(Exhibit.init(id: 4, name: "Scream", image: "scream", location: (Side.left, 8)))
        exhibits.append(Exhibit.init(id: 5, name: "Van Gogh", image: "night", location: (Side.bottom, 4)))
        
        museumMap = MuseumMap.init(frame: CGRect(x:0, y:0, width: 700, height: 800), exhibits: exhibits)
        museumMap.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        scroll.contentSize = museumMap.frame.size
        scroll.addSubview(museumMap)
        
        museumMap.getMap().printMap()
        
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
