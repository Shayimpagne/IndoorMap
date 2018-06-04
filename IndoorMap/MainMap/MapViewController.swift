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

class MapViewController: UIViewController, UIScrollViewDelegate {
    var scroll:UIScrollView!
    var museumMap:MuseumMap!
    var exhibits:[Exhibit]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        self.title = "Map"
        
        exhibits = initExhibits()
        
        //init view
        museumMap = MuseumMap.init(frame: CGRect(x:0, y:0, width: 1100, height: 800), exhibits: exhibits) //fixed size of real room (in cm)
        museumMap.backgroundColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 244/255.0, alpha: 1)
        scroll.contentSize = museumMap.frame.size
        scroll.delegate = self
        scroll.minimumZoomScale = 0.5
        scroll.maximumZoomScale = 5.0
        
        scroll.addSubview(museumMap)
        
        museumMap.getMap().printMap()
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
