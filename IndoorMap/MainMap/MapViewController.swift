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

class MapViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    var scroll:UIScrollView!
    var museumMap:MuseumMap!
    var exhibits:[Exhibit]!
    var descriptionView:DescriptionView!
    var clearView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.title = "Карта"
        
        exhibits = initExhibits()
        
        //init view
        museumMap = MuseumMap.init(frame: CGRect(x:0, y:0, width: 2600, height: 2600), exhibits: exhibits) //fixed size of real room (in cm)
        museumMap.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        scroll.contentSize = museumMap.frame.size
        scroll.delegate = self
        scroll.minimumZoomScale = 0.2
        scroll.maximumZoomScale = 2.0
        scroll.zoomScale = 0.2
        scroll.addSubview(museumMap)
        
        //museumMap.getMap().printMap()
        
        clearView = UIView.init(frame: self.view.frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(descriptionGesture(sender:)))
        tap.delegate = self
        clearView.addGestureRecognizer(tap)
        clearView.center.y += self.view.frame.height
        
        descriptionView = DescriptionView.init(frame: CGRect.zero)
        
        clearView.addSubview(descriptionView)
        self.view.addSubview(clearView)
        
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        let heightView = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        let viewLeading = NSLayoutConstraint(item: descriptionView, attribute: .leading, relatedBy: .equal, toItem: clearView, attribute: .leading, multiplier: 1, constant: 10)
        let viewTrailing = NSLayoutConstraint(item: descriptionView, attribute: .trailing, relatedBy: .equal, toItem: clearView, attribute: .trailing, multiplier: 1, constant: -10)
        let viewBottom = NSLayoutConstraint(item: descriptionView, attribute: .bottom, relatedBy: .equal, toItem: clearView, attribute: .bottom, multiplier: 1, constant: -10)
        
        clearView.addConstraints([heightView, viewLeading, viewTrailing, viewBottom])
        
        NotificationCenter.default.addObserver(self, selector: #selector(drawDescription(_:)), name: Notification.Name("description"), object: nil)
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
