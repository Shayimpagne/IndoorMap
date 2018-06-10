//
//  AudioMapViewController+InitGuides.swift
//  IndoorMap
//
//  Created by Emir Shayymov on 28.05.2018.
//  Copyright © 2018 Shayimpagne. All rights reserved.
//

import UIKit

extension AudioMapViewController {

    func initGuides() -> [Guide] {
        var guides:[Guide] = []
        
        //first room
        guides.append(Guide.init(1, (41, 41), "Справа вы можете увидеть картину Осипа Цадкина Керинейская Лань \n слева от картины керинейская лань можно увидеть картину Осипа цадкина Стимфалийские птицы \n сзади слева от вас картина Осипа Цадкина Эриманфский вепрь \n справа от вепря картина Осипа Цадкина Авгиевы коровы"))
        
        //second room
        guides.append(Guide.init(2, (40, 16), "Справа от вас находится картина Осипа Цадкина Герион \n Прямо можно увидеть картину Исаака Аскназия Портрет Девушки с веером \n Слева вы найдете картину Осипа Цадкина Немейкий Лев"))
        
        //third room
        guides.append(Guide.init(3, (22, 16), "Слева от вас вы увидите картину Якова Балглея Мальчик со скрипкой \n Далее от мальчика можно увидеть картину Якова Балглея Девочка С красным бантом \n Прямо вы увидите картину Льва Бакста К балету Клеопатра \n справа от Бакста картину Якова Балглея портрет девочки \n Справа картину Марка Шагала Жертвоприношение Афине \n Справа от Шагала картину Льва Бакста Автопортрет"))
        
        //fourth room
        guides.append(Guide.init(4, (8, 16), "Справа от вас находится картина Льва Бакста Аднрей Львович Бакст Сын художника \n Слева от вас картина Льва Бакста Ужин"))
        
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

}
