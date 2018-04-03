//
//  MapViewController.swift
//  IndoorMap
//
//  Created by Shayimpagne on 31.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet var scroll:UIScrollView!
    var museumMap:MuseumMap!
    var exhibits:[Exhibit] = []
    var descriptionView:DescriptionView!
    var clearView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray //UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        self.title = "Map"
        
        exhibits.append(Exhibit.init(id: 2, name: "Mona lisa", image: "monalisa", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 3, name: "Gustav Klimt", image: "kiss", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 4, name: "Mone", image: "mone", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 5, name: "Scream", image: "scream", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 6, name: "Van Gogh", image: "night", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 7, name: "Picasso Guernica", image: "guernica", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 8, name: "Van Gogh Night Cafe", image: "night_cafe", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 9, name: "Salvador Dali Time", image: "dali_time", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 10, name: "Rembrant Night", image: "rembrant_night", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        exhibits.append(Exhibit.init(id: 11, name: "Mikelangelo", image: "mikelangelo", description: "Mona Lisa was writing by famous Leonardo Da Vinci"))
        
        museumMap = MuseumMap.init(frame: CGRect(x:0, y:0, width: 1100, height: 800), exhibits: exhibits) //fixed size of real indoor (in cm)
        museumMap.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        scroll.contentSize = museumMap.frame.size
        scroll.delegate = self
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 5.0
        
        scroll.addSubview(museumMap)
        
        museumMap.getMap().printMap()
        
        clearView = UIView.init(frame: self.view.frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(descriptionGesture(sender:)))
        tap.delegate = self
        clearView.addGestureRecognizer(tap)
        clearView.center.y += self.view.frame.height
        
        descriptionView = DescriptionView.init(frame: CGRect.zero)
        
        clearView.addSubview(descriptionView)
        self.view.addSubview(clearView)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        let heightView = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
        let viewLeading = NSLayoutConstraint(item: descriptionView, attribute: .leading, relatedBy: .equal, toItem: clearView, attribute: .leading, multiplier: 1, constant: 10)
        let viewTrailing = NSLayoutConstraint(item: descriptionView, attribute: .trailing, relatedBy: .equal, toItem: clearView, attribute: .trailing, multiplier: 1, constant: -10)
        let viewBottom = NSLayoutConstraint(item: descriptionView, attribute: .bottom, relatedBy: .equal, toItem: clearView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -10)
        
        clearView.addConstraints([heightView, viewLeading, viewTrailing, viewBottom])
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(drawDescription(_:)), name: Notification.Name("description"), object: nil)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.museumMap
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func drawDescription(_ notification: NSNotification) {
        if let id = notification.userInfo?["id"] as? Int {
            getDescription(exhibit: self.museumMap.museum.getExhibit(id: id)!)
        }
    }
    
    func getDescription(exhibit: Exhibit) {
        descriptionView.setExhibit(exhibit: exhibit)
        
        UIView.animate(withDuration: 0.5, animations: ({
            self.clearView.center.y = self.view.center.y
        }))
    }
    
    @objc func descriptionGesture(sender: UITapGestureRecognizer? = nil) {
        hideView()
    }
    
    func hideView() {
        if self.clearView.center.y == self.view.center.y {
            UIView.animate(withDuration: 0.5, animations: ({
                self.clearView.center.y += self.view.frame.height
                self.museumMap.getExhibitViewByID(id: self.descriptionView.exhibit.id)?.resetExhibit()
            }))
        }
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
