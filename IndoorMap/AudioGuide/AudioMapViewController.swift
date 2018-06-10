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


class AudioMapViewController: MapViewController, CLLocationManagerDelegate, AVSpeechSynthesizerDelegate {
    @IBOutlet var mapScroll:UIScrollView!
    
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
        
        let stopButton = UIBarButtonItem(title: "stop", style: .done, target: self, action: #selector(stopPlaying))
        self.navigationItem.rightBarButtonItem = stopButton

        guides = initGuides()
        speechSynth.delegate = self
        
        resetBeacons()
    }
    
    @objc func stopPlaying() {
        if speechSynth.isSpeaking {
            speechSynth.stopSpeaking(at: .immediate)
        }
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
