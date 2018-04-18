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


class MapViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate {
    @IBOutlet var scroll:UIScrollView!
    var museumMap:MuseumMap!
    var exhibits:[Exhibit] = []
    var descriptionView:DescriptionView!
    var clearView:UIView!
    let uuid = UUID.init(uuidString: "52414449-5553-4E45-5457-4F524B53434F")//let uuid = UUID.init(uuidString: "628670F3-A35B-4D47-B60D-22C5FE10A300")
    var locationManager:CLLocationManager!
    var region:CLBeaconRegion!
    var t3:Trilateration!
    var dist1:Double = 0
    var dist2:Double = 0
    var dist3:Double = 0
    var position:(Double, Double) = (0, 0)
    let speechSynth = AVSpeechSynthesizer()
    var constants:[Constants] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.title = "Map"
        
        exhibits.append(Exhibit.init(id: 2, name: "Mona lisa", image: "monalisa", description: "Портрет Мона Лиза"))
        exhibits.append(Exhibit.init(id: 3, name: "Gustav Klimt", image: "kiss", description: "Картина Густава Климта \n Поцелуй"))
        exhibits.append(Exhibit.init(id: 4, name: "Mone", image: "mone", description: "Картина Клода Моне \n Лилии"))
        exhibits.append(Exhibit.init(id: 5, name: "Scream", image: "scream", description: "Картина Мунка \n Крик"))
        exhibits.append(Exhibit.init(id: 6, name: "Van Gogh", image: "night", description: "Картина Ван Гога \n Звездная Ночь"))
        exhibits.append(Exhibit.init(id: 7, name: "Picasso Guernica", image: "guernica", description: "Картина Пикассо \n Герника"))
        exhibits.append(Exhibit.init(id: 8, name: "Van Gogh Night Cafe", image: "night_cafe", description: "Картина Ван Гога \n Ночное Кафе"))
        exhibits.append(Exhibit.init(id: 9, name: "Salvador Dali Time", image: "dali_time", description: "Картина Сальвадора Дали \n Время"))
        exhibits.append(Exhibit.init(id: 10, name: "Rembrant Night", image: "rembrant_night", description: "Картина Рембранта \n Ночь"))
        exhibits.append(Exhibit.init(id: 11, name: "Mikelangelo", image: "mikelangelo", description: "Картина Микеланджело"))
        
        //first room
        constants.append(Constants.init(1, (19, 3), (14, 7), "Звёздная ночь \n картина нидерландского художника Винсента Ван Гога, написанная в июне 1889 года, с видом предрассветного неба над вымышленным городком из восточного окна жилища художника в Сен-Реми-де-Прованс \n Звёздная ночь была не первой попыткой Ван Гога изобразить ночное небо. \n В 1888 году в Арле он написал Звёздную ночь над Роной. \n Ван Гог хотел показать звёздную ночь, созданную силой воображения — более удивительную, чем ту, что можно наблюдать в реальности. \n В одном из писем он описывал сюжет будущей картины — звёздная ночь с кипарисами и, возможно, над полем спелой пшеницы. \n Свой замысел ему удалось осуществить в Сен-Реми. \n Винсент писал брату Тео: «Я по-прежнему нуждаюсь в религии. Потому я вышел ночью из дома и начал рисовать звёзды». \n \n Справа от вас «Герни́ка» — картина Пабло Пикассо, написанная в мае 1937 года по заказу правительства Испанской Республики для испанского павильона на Всемирной выставке в Париже. \n Тема картины, исполненной в манере кубизма и в чёрно-белой гамме, — бомбардировка Герники, произошедшая незадолго до этого, а также ужас апрельской испанской революции и Гражданской войны в Испании (1931—1939 годов)."))
        
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
        
        //resetBeacons()
        
//        t3 = Trilateration.init(x1: 9.0, y1: 14.0, dist1: 3.0, x2: 1.0, y2: 7.0, dist2: 2.0, x3: 12.0, y3: 2.0, dist3: 2.0)
//        museumMap.drawBeacons(x: 9, y: 14)
//        museumMap.drawBeacons(x: 1, y: 7)
//        museumMap.drawBeacons(x: 12, y: 2)
        
        NotificationCenter.default.addObserver(self, selector: #selector(drawDescription(_:)), name: Notification.Name("description"), object: nil)
    }
    
    func play(exhibit: Exhibit) {
        if !speechSynth.isSpeaking {
            let paragraphs = exhibit.description.components(separatedBy: "\n")
            
            for line in paragraphs {
                let speechUtterance = AVSpeechUtterance(string: line)
                speechUtterance.rate = 0.5
                speechUtterance.pitchMultiplier = 1.0
                speechUtterance.volume = 0.75
                speechUtterance.postUtteranceDelay = 0.005
                speechUtterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
                
                speechSynth.speak(speechUtterance)
            }
        } else {
            speechSynth.continueSpeaking()
        }
    }
    
    func testPlay(proximity: CLProximity) {
        var prox = ""
        
        switch proximity{
        case .immediate:
            prox = "immediate"
        case .near:
            prox = "near"
        case .far:
            prox = "far"
        default:
            prox = "unknown"
        }
        
        if !speechSynth.isSpeaking {
            
            let speechUtterance = AVSpeechUtterance(string: prox)
            speechUtterance.rate = 0.5
            speechUtterance.pitchMultiplier = 1.0
            speechUtterance.volume = 0.75
            speechUtterance.postUtteranceDelay = 0.005
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-EN")
            
            speechSynth.speak(speechUtterance)
        } else {
            speechSynth.continueSpeaking()
        }
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
    
    func resetBeacons() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        self.locationManager.requestAlwaysAuthorization()
        region = CLBeaconRegion.init(proximityUUID: uuid!, identifier: "museum_beacons")
        
        locationManager.stopMonitoring(for: region)
        locationManager.startMonitoring(for: region)
        locationManager.startRangingBeacons(in: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch (status) {
        case CLAuthorizationStatus.notDetermined:
            print("not authorized")
            break
        case CLAuthorizationStatus.authorized:
            print("authorized")
            break
        default:
            print("default value")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.locationManager.startRangingBeacons(in: self.region)
        print("entered")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.locationManager.stopRangingBeacons(in: self.region)
        print("exit")
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {

        for beacon in beacons {
            self.testPlay(proximity: beacon.proximity)
        }
//        for beacon in beacons {
//            if beacon.proximity == .near || beacon.proximity == .immediate {
//                //play(exhibit: self.museumMap.getMap().getExhibit(id: Int(beacon.minor))!)
//                self.museumMap.changeUserLocation(x: 10, y: 14)
//            }
//        }
    }
    
    func meters(rssi: Int) -> Double {
        let txPower:Double = -59
        
        if (rssi == 0) {
            return -1.0
        }
        
        let ratio = (Double(rssi) * 1.0) / txPower
        
        if (ratio < 1.0) {
            return pow(ratio, 10)
        } else {
            let distance = (0.89976) * pow(ratio, 7.7095) + 0.111
            return distance
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
