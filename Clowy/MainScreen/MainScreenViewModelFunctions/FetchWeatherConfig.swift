//
//  FetchWeatherConfig.swift
//  Clowy
//
//  Created by Egor Karpukhin on 29/12/2023.
//

import Foundation
import Firebase

func fetchWardrobe(configName: String ,completion: @escaping () -> ()) {
    var weatherConfig = OutfitConfig(name: "", weatherConfig: [])
    
    let urlString = "https://firebasestorage.googleapis.com:443/v0/b/fir-app-17e8c.appspot.com/o/configs/v1.0/normal/" + configName + "?alt=media&token=2158a184-ea2d-4300-8927-8569d153101c"
    if let url = URL.init(string: urlString) {
        print("URL IS OK")
        let resource = Kingfisher.ImageResource(downloadURL: url)
        
        KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
            switch result {
            case .success(let value):
                print(value.source)
                completion(value.image)
            case .failure(let value):
                completion(nil)
            }
        }
    }
}
