//
//  ClothImage.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 15.10.2022.
//

import SwiftUI
//import BackgroundRemoval
import Kingfisher
import FirebaseStorage

struct ClothImage: View {
    @StateObject var clothViewModel = ClothesCardViewModel.shared
    var imageName: String
    var isDeafult: Bool
    var color: String
    var rawImage: UIImage?
    
    @State var imageState: PlaceHolderState = .placeholder
    @State var removeBGState: PlaceHolderState = .placeholder
    @State var uiimage: UIImage = UIImage(systemName: "tshirt")!
    

//    func removeBG(image: UIImage, completion: @escaping (UIImage?) -> () ) {
//        completion(BackgroundRemoval.init().removeBackground(image: image))
//    }
    
    func getImage(image: String, completion: @escaping (UIImage?) -> () ) {
        let urlString = "https://firebasestorage.googleapis.com:443/v0/b/fir-app-17e8c.appspot.com/o/" + image + "?alt=media&token=2158a184-ea2d-4300-8927-8569d153101c"
        if let url = URL.init(string: urlString) {
            let resource = ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: [.forceRefresh], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    completion(value.image)
                case .failure(let value):
                    completion(nil)
                }
            }
        }
    }
    
    var body: some View {
        ZStack {
            if imageName != "" && rawImage == nil {
                if isDeafult == true {
                    Image(imageName)
                        .resizable()
                        .colorMultiply(Color(hex: color))
                } else {
//                    if imageState == .success {
                        let urlString = URL( string: "https://firebasestorage.googleapis.com:443/v0/b/fir-app-17e8c.appspot.com/o/" + imageName + "?alt=media&token=2158a184-ea2d-4300-8927-8569d153101c")
                        KFImage(urlString)
                            .resizable()
                            .placeholder {
                                ZStack {
                                    Circle()
                                        .foregroundColor(Color(hex: "#678CD4"))
                                        .opacity(0.2)
                                        .frame(width: 56, height: 56)
                                    Image("Veshalka")
                                        .resizable()
                                        .scaledToFit().frame(width: 24, height: 19)
                                        .foregroundColor(Color(hex: "#678CD4"))
                                }
                            }
//                    } else {
//                        Circle()
//                            .foregroundColor(Color(hex: "EEEFF1"))
//                            .onAppear {
//                                getImage(image: imageName) { im in
//                                    if let im = im {
//                                        removeBG(image: im) { newImage in
//                                            if let newImage = newImage {
//                                                uiimage = im
//                                                imageState = .success
//                                                clothViewModel.imageState = imageState
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                    }
                }
            } else {
                if let rawImage = rawImage {
//                    let editedImage = BackgroundRemoval.init().removeBackground(image: rawImage)
                    Image(uiImage: rawImage)
                        .resizable()
                }
                
            }
        }
    }
}

