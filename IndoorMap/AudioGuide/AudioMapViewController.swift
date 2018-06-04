//
//  MapViewController.swift
//  IndoorMap
//
//  Created by Shayimpagne on 31.03.18.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation


class AudioMapViewController: MapViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {
    @IBOutlet var mapScroll:UIScrollView!
    var descriptionView:DescriptionView!
    var clearView:UIView!
    let uuid = UUID.init(uuidString: "52414449-5553-4E45-5457-4F524B53434F")
    var locationManager:CLLocationManager!
    var region:CLBeaconRegion!
    var position:(Double, Double) = (0, 0)
    let speechSynth = AVSpeechSynthesizer()
    let audioSession = AVAudioSession.sharedInstance()
    var guides:[Guide]!
    var lastRoom = 0
    
    override func viewDidLoad() {
        super.scroll = mapScroll
        super.viewDidLoad()

        guides = initGuides()
        speechSynth.delegate = self
        
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
        let viewBottom = NSLayoutConstraint(item: descriptionView, attribute: .bottom, relatedBy: .equal, toItem: clearView, attribute: .bottom, multiplier: 1, constant: -10)
        
        clearView.addConstraints([heightView, viewLeading, viewTrailing, viewBottom])
        
        resetBeacons()
        
        NotificationCenter.default.addObserver(self, selector: #selector(drawDescription(_:)), name: Notification.Name("description"), object: nil)
    }
    
    func playGuide(currentGuide: Guide) {
        if !speechSynth.isSpeaking {
            play(text: currentGuide.description)
        } else {
            speechSynth.stopSpeaking(at: .immediate)
            play(text: currentGuide.description)
        }
    }
    
    func play(text: String) {
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback, with: AVAudioSessionCategoryOptions.duckOthers)
            
            let paragraphs = text.components(separatedBy: "\n")
            
            for line in paragraphs {
                let speechUtterance = AVSpeechUtterance(string: line)
                speechUtterance.rate = 0.5
                speechUtterance.pitchMultiplier = 1.0
                speechUtterance.volume = 0.75
                speechUtterance.postUtteranceDelay = 0.005
                speechUtterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
                
                speechSynth.speak(speechUtterance)
            }
            
            try audioSession.setActive(true)
        } catch {
            print("exception in playing text")
        }
        
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        do {
            try audioSession.setActive(false)
        } catch {
            print("error finishing")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if speechSynth.isSpeaking {
            speechSynth.stopSpeaking(at: .immediate)
        }
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
