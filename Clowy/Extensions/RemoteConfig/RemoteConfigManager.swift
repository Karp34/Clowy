//
//  RemoteConfigManager.swift
//  Clowy
//
//  Created by Egor Karpukhin on 30/12/2023.
//

import FirebaseRemoteConfig
import Foundation

struct RemoteConfigManager {
    static var remoteConfig: RemoteConfig = {
        var remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        remoteConfig.setDefaults(fromPlist: "remote_config_defaults")
//        var remoteConfigDefaults = [String: NSObject]()
//        let testArr: NSArray = []
//        remoteConfigDefaults["config"] = testArr
//        remoteConfig.setDefaults(remoteConfigDefaults)
        
        
        
        return remoteConfig
    }()

    static func configure() {
        remoteConfig.fetch { (status, error) in
            if status == .success {
                print("Config fetched!")
                self.remoteConfig.activate { changed, error in
                }
            } else {
                print("Config not fetched")
                print("Error: \(error?.localizedDescription ?? "No error available.")")
            }
        }
    }

    static func stringValue(forKey key: String) -> String {
        return remoteConfig.configValue(forKey: key).stringValue!
    }
    
    static func getOutfitConfig(forKey key: String) -> OutfitConfig {
        let data = remoteConfig.configValue(forKey: key).dataValue
        var outfitConfig = OutfitConfig(name: "", weatherConfig: [])
        print("GOT CONFIG")
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let jsonDictionary = json as? [String: Any] {
                let name = jsonDictionary["name"] as! String
                outfitConfig.name = name //SuperCold
                
                if let config = jsonDictionary["config"] as? [String: [String: [[String: String]]]] {
                    
                    for weathertype in config {
                        let weather = WeatherType(rawValue: weathertype.key)! //sunny
                        var weatherOutfits = [StyleOutfits]()
                        
                        for style in weathertype.value {
                            let styleName = OutfitStyle(rawValue: style.key)! //casual
                            var outfits = [[ClothesPref]]()
                        
                            for outfit in style.value {
                                var clothesPref = [ClothesPref]()
                                for cloth in outfit {
                                    let clothType = ClothesType(rawValue: cloth.key) ?? ClothesType.blank
                                    let temp = TemperatureType(rawValue: cloth.value)!
                                    
                                    clothesPref.append(ClothesPref(type: clothType, temp: temp))
                                }
                                outfits.append(clothesPref)
                            }
                            var clothes = StyleOutfits(style: styleName, outfits: outfits)
                            weatherOutfits.append(clothes)
                        }
                        
                        
                        var weatherConfig = WeatherConfig(weather: weather, clothes: weatherOutfits)
                        outfitConfig.weatherConfig.append(weatherConfig)
                    }
                }
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
        
        return outfitConfig
    }

}
