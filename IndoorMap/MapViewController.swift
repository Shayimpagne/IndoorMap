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
    var descriptionLorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam nisl ipsum, tempus eu ligula eu, molestie luctus augue. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec tincidunt, metus gravida vestibulum molestie, ante neque efficitur leo, vel laoreet sapien justo ac nibh. Pellentesque rutrum elit quis diam fringilla accumsan. Nulla fermentum malesuada ligula at mollis. Aliquam ut auctor est, quis lobortis sem. Duis imperdiet eget mauris vel suscipit. Nunc non nulla et erat tempor finibus. Aliquam euismod erat ut imperdiet dictum. Quisque commodo, turpis nec finibus vehicula, odio odio elementum odio, nec pretium nisl massa ut nisi. Donec ultrices efficitur pellentesque. Cras porttitor lacinia massa eget tincidunt. Donec ac tristique dui. Suspendisse pulvinar, purus non pretium ornare, est tortor pulvinar est, a viverra tellus turpis eget nibh. Suspendisse mattis cursus justo, ac placerat lacus lobortis ut. Sed ut mi hendrerit, convallis nibh in, interdum urna. Phasellus purus sapien, aliquet ac elementum vitae, fermentum ut nunc. Aenean dignissim, felis in convallis semper, magna quam elementum dolor, elementum interdum elit est eget nisl. Morbi posuere enim leo, sed sollicitudin tortor vestibulum quis. Aenean bibendum bibendum dolor at luctus. Aliquam ac suscipit arcu. Aliquam felis turpis, efficitur sit amet turpis vitae, suscipit dapibus dolor. Vivamus aliquam sem in erat efficitur, efficitur ultrices arcu maximus. Aliquam scelerisque felis vel metus porttitor aliquet. Nullam odio justo, lacinia sed dui ac, imperdiet posuere arcu. Proin sit amet facilisis enim. Aliquam iaculis urna vel sagittis auctor. Sed suscipit sed magna rutrum varius. Maecenas ut varius ipsum. Vivamus consequat tellus a diam venenatis ornare. Nullam venenatis ipsum nisl. Mauris nec condimentum metus, a rutrum ligula. Aenean efficitur, sem a egestas rutrum, turpis enim ornare elit, vel commodo augue nunc ut augue. Nullam sed porttitor nulla. Nunc consequat elementum leo et luctus. Phasellus congue porttitor aliquet. Nullam pellentesque eros sed erat condimentum, sed dictum felis porta. Ut ac congue tellus, in tincidunt nibh. Aliquam erat volutpat. Nulla ac libero vestibulum arcu lobortis condimentum vel vitae nunc. Curabitur vitae orci congue, semper neque sed, mollis augue. Mauris quis orci id tortor auctor interdum tincidunt sed sapien. Morbi feugiat laoreet nisl malesuada semper. Maecenas eu quam rhoncus, porta augue eu, commodo lectus. Proin rhoncus dictum feugiat. Suspendisse in vulputate ante. Nulla tincidunt, nulla in rhoncus convallis, diam velit gravida tellus, eget posuere lorem mi eget erat. Nunc bibendum vulputate sodales. Aliquam pellentesque aliquet tempus. Sed a purus in orci sodales cursus. Curabitur elit dolor, hendrerit cursus lacus at, laoreet venenatis neque. Curabitur quis nunc ac justo auctor luctus. Nulla bibendum pharetra est. Integer sollicitudin sapien justo, at cursus nisi maximus in. Cras vel odio et odio aliquam ultricies. Quisque quis elementum est, nec molestie augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Sed tincidunt augue ex, vel cursus sapien lacinia non. Sed felis nisi, egestas sit amet ex vel, semper ornare felis. Donec vel rhoncus est, vel facilisis orci. In tincidunt dui libero, non pretium massa suscipit vitae. Duis a rhoncus nulla."

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray //UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        self.title = "Map"
        
        exhibits.append(Exhibit.init(id: 2, name: "Mona lisa", image: "monalisa", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 3, name: "Gustav Klimt", image: "kiss", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 4, name: "Mone", image: "mone", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 5, name: "Scream", image: "scream", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 6, name: "Van Gogh", image: "night", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 7, name: "Picasso Guernica", image: "guernica", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 8, name: "Van Gogh Night Cafe", image: "night_cafe", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 9, name: "Salvador Dali Time", image: "dali_time", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 10, name: "Rembrant Night", image: "rembrant_night", description: descriptionLorem))
        exhibits.append(Exhibit.init(id: 11, name: "Mikelangelo", image: "mikelangelo", description: descriptionLorem))
        
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
