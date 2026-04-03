//
//  OutfitConfig.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 03.12.2022.
//

import Foundation

struct OutfitConfig: Codable {
    var name: String
    var weatherConfig: [WeatherConfig]
}

struct WeatherConfig: Codable {
    var weather: WeatherType
    var clothes: [StyleOutfits]
}

enum WeatherType: String, CaseIterable, Codable {
    case sunny = "sunny"
    case rain = "rain"
    case humidity = "humid"
    case cloudyOrWindy = "cloudyOrWindy"
}

struct StyleOutfits: Codable {
    var style: OutfitStyle
    var outfits: [[ClothesPref]]
}

enum OutfitStyle: String, CaseIterable, Codable {
    case business = "business"
    case casual = "casual"
//    case sport = "sport"
}

struct ClothesPref: Codable {
    var type: ClothesType
    var temp: TemperatureType
}

struct NotRealCloth: Codable {
    var id: String
    var type: ClothesType
    var temp: TemperatureType
}


//let clothes : [String: [String: String]] = [
//    "super_cold": [
////        #temp0 <= -20
//        "jacket": "cold",
//        "upper_wear": "sweater",
//        "second_sweater": "cold",
//        "t-shirt": "regular",
//        "pants": "cold",
//        "warm_pants": "cold",
//        "socks": "regular",
//        "warm_socks": "cold",
//        "sneakers": "cold",
//        "hat": "cold",
//        "warm_gloves": "cold",
//        "scarf": "cold"
//    ],
//    "cold":[
////        #temp0 <= -5 and temp0 > -20
//        "jacket": "cold",
//        "upper_wear": "sweater",
//        "second_sweater": False,
//        "t-shirt": "regular",
//        "pants": "regular",
//        "warm_pants": "cold",
//        "socks": "regular",
//        "warm_socks": False,
//        "sneakers": "cold",
//        "hat": "cold",
//        "warm_gloves": "cold"
//    ],
//    "coldy":[
////        #temp0 <= 5 and temp0 > -5
//        "jacket": "coldy",
//        "upper_wear": "sweater",
//        "second_sweater": False,
//        "t-shirt": "regular",
//        "pants": "regular",
//        "warm_pants": False,
//        "socks": "regular",
//        "warm_socks": False,
//        "sneakers": [
//            "regular",
//            "cold",
//            "regular",
//            "cold"],
//        "hat": [
//            "cold",
//            False],
//        "umbrella":[
//            False,
//            "regular"]
//    ],
//    "regular":[
////        #temp0 <= 15 and temp0 > 5
//        "jacket": [
//          "regular",
//          "regular",
//          "regular",
//          "regular"],
//        "upper_wear": "sweater",
//        "second_sweater": False,
//        "t-shirt": "regular",
//        "pants": "regular",
//        "warm_pants": False,
//        "socks": "regular",
//        "warm_socks": False,
//        "sneakers" : "regular",
//        "hat": False,
//        "sunglasses": False,
//        "umbrella":[
//            False,
//            "regular",
//            False,
//            "regular"]
//    ],
//    "warm":[
////        #temp0 <= 20 and temp0 > 15
//        "jacket": False,
//        "upper_wear": [
//            "sweater",
//            "sweater",
//            False,
//            "sweater"],
//        "second_sweater": False,
//        "t-shirt": "regular",
//        "pants": "regular",
//        "warm_pants": False,
//        "socks": [
//            "warm",
//            "regular",
//            "warm",
//            "regular"],
//        "warm_socks": False,
//        "sneakers": [
//            "warm",
//            "regular",
//            "warm"],
//        "hat": False,
//        "sunglasses": False,
//        "umbrella":[
//            False,
//            "regular",
//            False,
//            "regular"]
//    ],
//    "hot":[
////        # temp0 > 20
//        "jacket": False,
//        "upper_wear": [
//            False,
//            "shirt",
//            False,
//            False],
//        "second_sweater": False,
//        "t-shirt": [
//            "regular",
//            False,
//            "regular",
//            "regular"],
//        "pants": [
//            "hot",
//            "regular",
//            "hot",
//            "hot"],
//        "warm_pants": False,
//        "socks": [
//            "warm",
//            "regular",
//            "warm",
//            "warm"],
//        "warm_socks": False,
//        "sneakers": "warm",
//        "hat": False,
//        "sunglasses": [
//            False,
//            "regular",
//            False,
//            False],
//        "umbrella":[
//            False,
//            "regular",
//            False,
//            "regular"]
//    ]
//]


//let outfitConfig: [OutfitConfig] = [
//    OutfitConfig(name: "SuperCold", weatherConfig: [
//        WeatherConfig(weather: .sunny, clothes: [
//            [ClothesPref(type: .jackets, temp: .superCold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .thermals, temp: .superCold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .superCold),
//             ClothesPref(type: .socks, temp: .superCold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .superCold),
//             ClothesPref(type: .gloves, temp: .superCold),
//             ClothesPref(type: .scarves, temp: .superCold)],
//
//            // I did it because some people do not wear t-shirts under hoodies. I need another way to do this
//            [ClothesPref(type: .jackets, temp: .superCold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .thermals, temp: .superCold),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .superCold),
//             ClothesPref(type: .socks, temp: .superCold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .superCold),
//             ClothesPref(type: .gloves, temp: .superCold),
//             ClothesPref(type: .scarves, temp: .superCold)]
//        ]),
//
//        WeatherConfig(weather: .rain, clothes: [
//            [ClothesPref(type: .jackets, temp: .superCold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .thermals, temp: .superCold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .superCold),
//             ClothesPref(type: .socks, temp: .superCold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .superCold),
//             ClothesPref(type: .gloves, temp: .superCold),
//             ClothesPref(type: .scarves, temp: .superCold)]
//        ]),
//
//        WeatherConfig(weather: .humidity, clothes: [
//            [ClothesPref(type: .jackets, temp: .superCold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .thermals, temp: .superCold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .superCold),
//             ClothesPref(type: .socks, temp: .superCold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .superCold),
//             ClothesPref(type: .gloves, temp: .superCold),
//             ClothesPref(type: .scarves, temp: .superCold)]
//        ]),
//
//        WeatherConfig(weather: .lightRain, clothes: [
//            [ClothesPref(type: .jackets, temp: .superCold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .thermals, temp: .superCold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .superCold),
//             ClothesPref(type: .socks, temp: .superCold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .superCold),
//             ClothesPref(type: .gloves, temp: .superCold),
//             ClothesPref(type: .scarves, temp: .superCold)]
//        ]),
//    ]),
//
//    OutfitConfig(name: "Cold", weatherConfig: [
//        WeatherConfig(weather: .sunny, clothes: [
//            [ClothesPref(type: .jackets, temp: .cold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .cold),
//             ClothesPref(type: .socks, temp: .cold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .cold),
//             ClothesPref(type: .gloves, temp: .cold),
//             ClothesPref(type: .scarves, temp: .cold)]
//        ]),
//
//        WeatherConfig(weather: .rain, clothes: [
//            [ClothesPref(type: .jackets, temp: .cold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .cold),
//             ClothesPref(type: .socks, temp: .cold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .cold),
//             ClothesPref(type: .gloves, temp: .cold),
//             ClothesPref(type: .scarves, temp: .cold)]
//        ]),
//
//        WeatherConfig(weather: .humidity, clothes: [
//            [ClothesPref(type: .jackets, temp: .cold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .cold),
//             ClothesPref(type: .socks, temp: .cold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .cold),
//             ClothesPref(type: .gloves, temp: .cold),
//             ClothesPref(type: .scarves, temp: .cold)]
//        ]),
//
//        WeatherConfig(weather: .lightRain, clothes: [
//            [ClothesPref(type: .jackets, temp: .cold),
//             ClothesPref(type: .hoodies, temp: .cold),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .cold),
//             ClothesPref(type: .thermalPants, temp: .cold),
//             ClothesPref(type: .socks, temp: .cold),
//             ClothesPref(type: .sneakers, temp: .cold),
//             ClothesPref(type: .headdresses, temp: .cold),
//             ClothesPref(type: .gloves, temp: .cold),
//             ClothesPref(type: .scarves, temp: .cold)]
//        ]),
//    ]),
//
//    OutfitConfig(name: "Coldy", weatherConfig: [
//        WeatherConfig(weather: .sunny, clothes: [
//            [ClothesPref(type: .jackets, temp: .coldy),
//             ClothesPref(type: .hoodies, temp: .coldy),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .coldy),
//             ClothesPref(type: .socks, temp: .coldy),
//             ClothesPref(type: .sneakers, temp: .regular),
//             ClothesPref(type: .headdresses, temp: .coldy),
//             ClothesPref(type: .gloves, temp: .coldy),
//             ClothesPref(type: .scarves, temp: .coldy)],
//
//            [ClothesPref(type: .jackets, temp: .regular),
//             ClothesPref(type: .dresses, temp: .regular),
//             ClothesPref(type: .sneakers, temp: .regular),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .jackets, temp: .warm),
//             ClothesPref(type: .hoodies, temp: .warm),
//             ClothesPref(type: .skirts, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .rain, clothes: [
//            [ClothesPref(type: .jackets, temp: .coldy),
//             ClothesPref(type: .hoodies, temp: .coldy),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .coldy),
//             ClothesPref(type: .socks, temp: .coldy),
//             ClothesPref(type: .sneakers, temp: .coldy),
//             ClothesPref(type: .headdresses, temp: .coldy),
//             ClothesPref(type: .gloves, temp: .coldy),
//             ClothesPref(type: .scarves, temp: .coldy)]
//        ]),
//
//        WeatherConfig(weather: .humidity, clothes: [
//            [ClothesPref(type: .jackets, temp: .coldy),
//             ClothesPref(type: .hoodies, temp: .coldy),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .coldy),
//             ClothesPref(type: .socks, temp: .coldy),
//             ClothesPref(type: .sneakers, temp: .regular),
//             ClothesPref(type: .headdresses, temp: .coldy),
//             ClothesPref(type: .gloves, temp: .coldy),
//             ClothesPref(type: .scarves, temp: .coldy)]
//        ]),
//
//        WeatherConfig(weather: .lightRain, clothes: [
//            [ClothesPref(type: .jackets, temp: .coldy),
//             ClothesPref(type: .hoodies, temp: .coldy),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .coldy),
//             ClothesPref(type: .socks, temp: .coldy),
//             ClothesPref(type: .sneakers, temp: .coldy),
//             ClothesPref(type: .headdresses, temp: .coldy),
//             ClothesPref(type: .gloves, temp: .coldy),
//             ClothesPref(type: .scarves, temp: .coldy)]
//        ]),
//    ]),
//
//    OutfitConfig(name: "Regular", weatherConfig: [
//        WeatherConfig(weather: .sunny, clothes: [
//            [ClothesPref(type: .jackets, temp: .regular),
//             ClothesPref(type: .hoodies, temp: .regular),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .regular),
//             ClothesPref(type: .socks, temp: .regular),
//             ClothesPref(type: .sneakers, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .rain, clothes: [
//            [ClothesPref(type: .jackets, temp: .regular),
//             ClothesPref(type: .hoodies, temp: .regular),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .regular),
//             ClothesPref(type: .socks, temp: .regular),
//             ClothesPref(type: .sneakers, temp: .regular),
//             ClothesPref(type: .umbrellas, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .humidity, clothes: [
//            [ClothesPref(type: .jackets, temp: .regular),
//             ClothesPref(type: .hoodies, temp: .regular),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .regular),
//             ClothesPref(type: .socks, temp: .regular),
//             ClothesPref(type: .sneakers, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .lightRain, clothes: [
//            [ClothesPref(type: .jackets, temp: .regular),
//             ClothesPref(type: .hoodies, temp: .regular),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .regular),
//             ClothesPref(type: .socks, temp: .regular),
//             ClothesPref(type: .sneakers, temp: .regular),
//             ClothesPref(type: .umbrellas, temp: .regular)]
//        ]),
//    ]),
//
//    OutfitConfig(name: "Warm", weatherConfig: [
//        WeatherConfig(weather: .sunny, clothes: [
//            [ClothesPref(type: .hoodies, temp: .warm),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .warm),
//             ClothesPref(type: .socks, temp: .warm),
//             ClothesPref(type: .sneakers, temp: .warm)],
//
//            [ClothesPref(type: .hoodies, temp: .warm),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .jackets, temp: .warm),
//             ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .jackets, temp: .warm),
//             ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .rain, clothes: [
//            [ClothesPref(type: .jackets, temp: .warm),
//             ClothesPref(type: .hoodies, temp: .warm),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .warm),
//             ClothesPref(type: .socks, temp: .regular),
//             ClothesPref(type: .sneakers, temp: .regular),
//             ClothesPref(type: .umbrellas, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .humidity, clothes: [
//            [ClothesPref(type: .jackets, temp: .hot),
//             ClothesPref(type: .hoodies, temp: .warm),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .warm),
//             ClothesPref(type: .socks, temp: .warm),
//             ClothesPref(type: .sneakers, temp: .warm)],
//
//            [ClothesPref(type: .jackets, temp: .hot),
//             ClothesPref(type: .hoodies, temp: .warm),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .jackets, temp: .warm),
//             ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .jackets, temp: .warm),
//             ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)]
//            ]),
//
//        WeatherConfig(weather: .lightRain, clothes: [
//            [ClothesPref(type: .jackets, temp: .warm),
//             ClothesPref(type: .hoodies, temp: .warm),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .warm),
//             ClothesPref(type: .socks, temp: .regular),
//             ClothesPref(type: .sneakers, temp: .regular),
//             ClothesPref(type: .umbrellas, temp: .regular)]
//        ]),
//    ]),
//
//    OutfitConfig(name: "Hot", weatherConfig: [
//        WeatherConfig(weather: .sunny, clothes: [
//            [ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .rain, clothes: [
//            [ClothesPref(type: .jackets, temp: .hot),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .warm),
//             ClothesPref(type: .socks, temp: .warm),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .umbrellas, temp: .regular)],
//
//            [ClothesPref(type: .jackets, temp: .hot),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .skirts, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .umbrellas, temp: .regular)],
//
//            [ClothesPref(type: .jackets, temp: .hot),
//             ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .skirts, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .umbrellas, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .humidity, clothes: [
//            [ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)],
//
//            [ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular)]
//        ]),
//
//        WeatherConfig(weather: .lightRain, clothes: [
//            [ClothesPref(type: .tshirts, temp: .regular),
//             ClothesPref(type: .pants, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular),
//             ClothesPref(type: .umbrellas, temp: .regular)],
//
//            [ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .socks, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular),
//             ClothesPref(type: .umbrellas, temp: .regular)],
//
//            [ClothesPref(type: .dresses, temp: .hot),
//             ClothesPref(type: .sneakers, temp: .hot),
//             ClothesPref(type: .sunglasses, temp: .regular),
//             ClothesPref(type: .umbrellas, temp: .regular)]
//        ]),
//    ]),
//]
