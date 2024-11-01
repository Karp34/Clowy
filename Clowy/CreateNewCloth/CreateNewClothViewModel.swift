//
//  CreateNewClothViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.11.2024.
//

import SwiftUI
import FirebaseStorage
import Firebase

class CreateNewClothViewModel: ObservableObject {
    @StateObject private var mainViewModel = MainScreenViewModel.shared
    
    @Published var cloth: Cloth = Cloth(id:  UUID().uuidString, name: "", type: .blank, color: "#FFFFFF", temperature: [], isDefault: false, image: "", rawImage: nil, creationDate: 0)
    @Published var temp: [Temperature] = []
    @Published var imageId: String = ""

    static var shared = CreateNewClothViewModel()
    
    func reset() {
        cloth = Cloth(id:  UUID().uuidString, name: "", type: .blank, color: "#FFFFFF", temperature: [], isDefault: false, image: "", rawImage: nil, creationDate: 0)
        temp = []
    }
    
    func createTempNames() -> [String] {
        
        var tempNames: [String] = []
        for item in temp {
            tempNames.append(item.name)
        }
        return tempNames
    }
    
    func addImageToStorage(fileName: String) {
        let ref = Storage.storage().reference(withPath: fileName)
        guard let imageData = self.cloth.rawImage?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print(error)
                return
            }
            ref.downloadURL { url, err in
                if let error = error {
                    print(error)
                    return
                }
            }
        }
    }
    
    func addCloth(name: String, image: String, type: String, temp: [String], color: String, isDefault: Bool) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(mainViewModel.userId).collection("Wardrobe")
        ref.addDocument(data: ["name": name, "type": type, "image" : image, "temp": temp, "color": color, "isDefault": isDefault, "creationDate": Int(Date().timeIntervalSince1970)]) { error in
            if error == nil {
                self.mainViewModel.fetchWardrobe() {
                    
                    self.mainViewModel.getRightOutfits()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func updateCloth(name: String, image: String, type: String, temp: [String], color: String, isDefault: Bool) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(mainViewModel.userId).collection("Wardrobe")
        
        ref.document(cloth.id).setData(["name": name, "type": type, "image" : image, "temp": temp, "color": color, "isDefault": isDefault, "creationDate": Int(Date().timeIntervalSince1970)]) { error in
            if error == nil {
                self.mainViewModel.fetchWardrobe() {
                     
                    self.mainViewModel.getRightOutfits()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func deleteFromStorage(imageId: String, completion: @escaping () -> ()) {
        let ref = Storage.storage().reference()
        let desertRef = ref.child(imageId)
        
        desertRef.delete { error in
            if let error = error {
                print("Error")
                print(error.localizedDescription)
                completion()
            } else {
                print("Success")
                completion()
            }
        }
    }
    
    func updateImage(imageId: String) {
        deleteFromStorage(imageId: imageId) {
            print("sterted")
            self.addImageToStorage(fileName: imageId)
        }
    }
}
