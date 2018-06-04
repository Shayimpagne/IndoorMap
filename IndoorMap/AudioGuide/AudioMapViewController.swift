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
    var descriptionView:DescriptionView!
    var clearView:UIView!
    let uuid = UUID.init(uuidString: "52414449-5553-4E45-5457-4F524B53434F")
    var locationManager:CLLocationManager!
    var region:CLBeaconRegion!
    var position:(Double, Double) = (0, 0)
    let speechSynth = AVSpeechSynthesizer()
    var guides:[Guide]!
    var exhibits:[Exhibit]!
    var lastRoom = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.title = "Map"
        
        exhibits = initExhibits()
    
        // init guides
        guides = initGuides()
        
        //init view
        museumMap = MuseumMap.init(frame: CGRect(x:0, y:0, width: 1100, height: 800), exhibits: exhibits) //fixed size of real room (in cm)
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
        //let viewBottom = NSLayoutConstraint(item: descriptionView, attribute: .bottom, relatedBy: .equal, toItem: clearView.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: -10)
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if speechSynth.isSpeaking {
            speechSynth.stopSpeaking(at: .word)
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
            if beacon.proximity == .immediate {
                if let currentGuide = getGuideByID(id: Int(truncating: beacon.minor), in: guides) {
                    if lastRoom != currentGuide.id {
                        lastRoom = currentGuide.id
                        museumMap.changeUserLocation(x: currentGuide.location.0, y: currentGuide.location.1)
                        playGuide(currentGuide: currentGuide)
                    }
                    
                }
            }
        }
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
    
    func initGuides() -> [Guide] {
        var guides:[Guide] = []
        
        //first room
        guides.append(Guide.init(1, (15, 8), "Справа вы можете увидеть картину Звёздная ночь \n картина нидерландского художника Винсента Ван Гога, написанная в июне 1889 года, с видом предрассветного неба над вымышленным городком из восточного окна жилища художника в Сен-Реми-де-Прованс \n Звёздная ночь была не первой попыткой Ван Гога изобразить ночное небо. \n Ван Гог хотел показать звёздную ночь, созданную силой воображения — более удивительную, чем ту, что можно наблюдать в реальности. \n \n Справа от вас, если вы пройдете дальше \n «Герни́ка» — картина Пабло Пикассо, написанная в мае 1937 года по заказу правительства Испанской Республики для испанского павильона на Всемирной выставке в Париже. \n Тема картины, исполненной в манере кубизма и в чёрно-белой гамме, — бомбардировка Герники, произошедшая незадолго до этого, а также ужас апрельской испанской революции и Гражданской войны в Испании (1931—1939 годов). \n \n Справа от Герники вы можете увидеть знаменитую картину Эдварда Мунка - Крик. \n Фигура кричащего примитивизирована до такой степени, что напоминает различным комментаторам скелет, эмбрион или сперматозоид. \n Волнообразные линии пейзажа, будто эхо, повторяют закруглённые контуры головы и широко раскрытого рта — как если бы звук крика отдавался повсюду. \n \n Справа от вас можно увидеть картину Клода Моне - Парусники \n Написанная картина «Парусники», а также ряд других картин с подобным названием можно сказать с натуры, в бытность жизни художника на берегу Сены, река эта была облюбована местными любителями парусной регаты, проводившейся с наступлением подходящей погоды на протяжении многих лет. Именно поэтому перед зрителями предстоят, то парусники осенью, то летом, а то и в зимнее время. \n \n Справа от картины парусники вы можете увидеть знаменитую картину Да Винчи - Мона Лиза \n Ей было посвящено всё время, остававшееся у него от работы над «Битвой при Ангиари». Он потратил на него значительное время и, покидая Италию в зрелом возрасте, увёз с собой во Францию в числе некоторых других избранных картин. \n Да Винчи испытывал особенную привязанность к этому портрету, а также много размышлял во время процесса его создания, в «Трактате о живописи» и в тех заметках о технике живописи, которые не вошли в него, можно найти множество указаний, с несомненностью относящихся к «Джоконде». \n \n Справа от портрета Мона Лизы вы можете встретить еще одну из картин Ван Гога -  Ночное Кафе. \n Для творчества Ван Гога данная картина является уникальной. Винсенту ван Гогу претила обыденность, и в этой картине он её мастерски преодолевает. \n Интересной особенностью является то, что при написании картины художник не использовал ни грамма чёрной краски, и тем не менее, ему удалось мастерски изобразить ночное небо и необыкновенное сияние звёзд. \n \n Вы просмотрели все картины в данном зале, можете пройти в следующий зал."))
        
        //second room
        guides.append(Guide.init(2, (4, 4), "Справа вы можете увидеть картину Сальвадора Дали - Постоянство Памяти \n Эта небольшая картина — вероятно, самая известная работа Дали. \n Размягченность висящих и стекающих часов — образ, выражающий уход от линейного понимания времени. \n Здесь присутствует и сам Дали в виде спящей головы, уже появлявшейся в «Траурной игре» и других картинах. \n \n Слева от картины Сальвадора Дали вы можете увидеть картину Рембрандта - Ночной Дозор \n Картина была написана по заказу Стрелкового общества — отряда гражданского ополчения Нидерландов, пожелавшего украсить своё новое здание групповыми портретами шести рот. \n Рембрандту портрет заказала стрелковая рота капитана Франса Баннинга Кока и заплатила 1600 флоринов. \n В XVIII веке полотно обрезали со всех сторон, чтобы картина поместилась в новом зале. \n Больше всего пострадала левая часть картины, где исчезли два стрелка. \n Сохранилась копия XVII века (Геррита Люнденса, хранится в Лондонской Национальной галерее), по которой можно судить об утраченной части картины. \n \n Вы просмотрели все картины в данном зале, можете пройти в следующий зал."))
        
        //third room
        guides.append(Guide.init(3, (7, 14), "Слева вы можете увидеть картину Густава Климта - Поцелуй \n Полотно принадлежит к периоду творчества Климта, названному «золотым»: \n в это время художник много работал с золотым цветом и настоящим листовым сусальным золотом. \n Популярность картин этого времени, и «Поцелуя» в том числе, связана не в последнюю очередь с применением художником золота в качестве цвета. \n Золото с незапамятных времён вызывает магические, религиозные ассоциации в равной мере с чувством материальной ценности, значимости. \n \n Справа немного пройдя прямо вы можете рассмотреть картину Микеланджело - «Сотворение Адама» \n одна из самых выдающихся композиций росписи Сикстинской капеллы. \n В бесконечном пространстве летит Бог-Отец, окружённый бескрылыми ангелами, с реющей белой туникой. \n Правая рука вытянута навстречу руке Адама и почти касается её. \n Лежащее на зелёной скале тело Адама постепенно приходит в движение, пробуждается к жизни. \n Вся композиция сконцентрирована на жесте двух рук. \n Рука Бога даёт импульс, а рука Адама принимает его, давая всему телу жизненную энергию. \n Тем, что их руки не соприкасаются, Микеланджело подчеркнул невозможность соединения божественного и человеческого.\n \n Вы просмотрели все картины в данном зале, можете пройти в следующий зал."))
        
        return guides
        
    }
    
    func getGuideByID(id: Int, in guidesArray: [Guide]) -> Guide? {
        for guide in guidesArray {
            if id == guide.id {
                return guide
            }
        }
        
        return nil
    }
    
    func initExhibits() -> [Exhibit] {
        var exhibits:[Exhibit] = []
        
        exhibits.append(Exhibit.init(id: 2, name: "Mona lisa", image: "monalisa", description: "Да Винчи - Мона Лиза \n Ей было посвящено всё время, остававшееся у него от работы над «Битвой при Ангиари». Он потратил на него значительное время и, покидая Италию в зрелом возрасте, увёз с собой во Францию в числе некоторых других избранных картин. \n Да Винчи испытывал особенную привязанность к этому портрету, а также много размышлял во время процесса его создания, в «Трактате о живописи» и в тех заметках о технике живописи, которые не вошли в него, можно найти множество указаний, с несомненностью относящихся к «Джоконде»."))
        exhibits.append(Exhibit.init(id: 3, name: "Gustav Klimt", image: "kiss", description: "Картина Густава Климта - Поцелуй \n Полотно принадлежит к периоду творчества Климта, названному «золотым»: \n в это время художник много работал с золотым цветом и настоящим листовым сусальным золотом. \n Популярность картин этого времени, и «Поцелуя» в том числе, связана не в последнюю очередь с применением художником золота в качестве цвета. \n Золото с незапамятных времён вызывает магические, религиозные ассоциации в равной мере с чувством материальной ценности, значимости."))
        exhibits.append(Exhibit.init(id: 4, name: "Mone", image: "mone", description: "Клод Моне - Парусники \n Написанная картина «Парусники», а также ряд других картин с подобным названием можно сказать с натуры, в бытность жизни художника на берегу Сены, река эта была облюбована местными любителями парусной регаты, проводившейся с наступлением подходящей погоды на протяжении многих лет. Именно поэтому перед зрителями предстоят, то парусники осенью, то летом, а то и в зимнее время."))
        exhibits.append(Exhibit.init(id: 5, name: "Scream", image: "scream", description: "Эдвард Мунк - Крик \n Фигура кричащего примитивизирована до такой степени, что напоминает различным комментаторам скелет, эмбрион или сперматозоид. \n Волнообразные линии пейзажа, будто эхо, повторяют закруглённые контуры головы и широко раскрытого рта — как если бы звук крика отдавался повсюду."))
        exhibits.append(Exhibit.init(id: 6, name: "Van Gogh", image: "night", description: "Звёздная ночь \n картина нидерландского художника Винсента Ван Гога, написанная в июне 1889 года, с видом предрассветного неба над вымышленным городком из восточного окна жилища художника в Сен-Реми-де-Прованс \n Звёздная ночь была не первой попыткой Ван Гога изобразить ночное небо. \n Ван Гог хотел показать звёздную ночь, созданную силой воображения — более удивительную, чем ту, что можно наблюдать в реальности."))
        exhibits.append(Exhibit.init(id: 7, name: "Picasso Guernica", image: "guernica", description: "«Герни́ка» — картина Пабло Пикассо, написанная в мае 1937 года по заказу правительства Испанской Республики для испанского павильона на Всемирной выставке в Париже. \n Тема картины, исполненной в манере кубизма и в чёрно-белой гамме, — бомбардировка Герники, произошедшая незадолго до этого, а также ужас апрельской испанской революции и Гражданской войны в Испании (1931—1939 годов)."))
        exhibits.append(Exhibit.init(id: 8, name: "Van Gogh Night Cafe", image: "night_cafe", description: "Ван Гог -  Ночное Кафе. \n Для творчества Ван Гога данная картина является уникальной. Винсенту ван Гогу претила обыденность, и в этой картине он её мастерски преодолевает. \n Интересной особенностью является то, что при написании картины художник не использовал ни грамма чёрной краски, и тем не менее, ему удалось мастерски изобразить ночное небо и необыкновенное сияние звёзд."))
        exhibits.append(Exhibit.init(id: 9, name: "Salvador Dali Time", image: "dali_time", description: "Эта небольшая картина — вероятно, самая известная работа Дали. \n Размягченность висящих и стекающих часов — образ, выражающий уход от линейного понимания времени. \n Здесь присутствует и сам Дали в виде спящей головы, уже появлявшейся в «Траурной игре» и других картинах."))
        exhibits.append(Exhibit.init(id: 10, name: "Rembrant Night", image: "rembrant_night", description: "Рембрандт - Ночной Дозор \n Картина была написана по заказу Стрелкового общества — отряда гражданского ополчения Нидерландов, пожелавшего украсить своё новое здание групповыми портретами шести рот. \n Рембрандту портрет заказала стрелковая рота капитана Франса Баннинга Кока и заплатила 1600 флоринов. \n В XVIII веке полотно обрезали со всех сторон, чтобы картина поместилась в новом зале. \n Больше всего пострадала левая часть картины, где исчезли два стрелка. \n Сохранилась копия XVII века (Геррита Люнденса, хранится в Лондонской Национальной галерее), по которой можно судить об утраченной части картины."))
        exhibits.append(Exhibit.init(id: 11, name: "Mikelangelo", image: "mikelangelo", description: "Картина Микеланджело - «Сотворение Адама» \n одна из самых выдающихся композиций росписи Сикстинской капеллы. \n В бесконечном пространстве летит Бог-Отец, окружённый бескрылыми ангелами, с реющей белой туникой. \n Правая рука вытянута навстречу руке Адама и почти касается её. \n Лежащее на зелёной скале тело Адама постепенно приходит в движение, пробуждается к жизни. \n Вся композиция сконцентрирована на жесте двух рук. \n Рука Бога даёт импульс, а рука Адама принимает его, давая всему телу жизненную энергию. \n Тем, что их руки не соприкасаются, Микеланджело подчеркнул невозможность соединения божественного и человеческого."))
        
        return exhibits
    }
    
    func getExhibitByID(id: Int, in exhibitsArray: [Exhibit]) -> Exhibit? {
        for exhibit in exhibitsArray {
            if id == exhibit.id {
                return exhibit
            }
        }
        
        return nil
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
