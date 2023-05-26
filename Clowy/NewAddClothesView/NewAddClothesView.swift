//
//  AddClothesView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 18.01.2022.
//

import SwiftUI
import FirebaseStorage
import Firebase


class AddClothesViewModel: ObservableObject {
    @StateObject private var mainViewModel = MainScreenViewModel.shared
    
    @Published var cloth: Cloth = Cloth(id:  UUID().uuidString, name: "", type: .blank, color: "#FFFFFF", temperature: [], isDefault: false, image: "", rawImage: nil)
//    @Published var id: String = UUID().uuidString
//    @Published var name: String = ""
//    @Published var clothesType: ClothesType = .blank
    @Published var temp: [Temperature] = []
    @Published var imageId: String = ""
//    @Published var rawImage: UIImage? = nil
//    @Published var chosenColor: String = "#FFFFFF"
//    @Published var isDefault: Bool = false
    
    
    
    static var shared = AddClothesViewModel()
    
    func reset() {
        cloth = Cloth(id:  UUID().uuidString, name: "", type: .blank, color: "#FFFFFF", temperature: [], isDefault: false, image: "", rawImage: nil)
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
        ref.addDocument(data: ["name": name, "type": type, "image" : image, "temp": temp, "color": color, "isDefault": isDefault]) { error in
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
        
        ref.document(cloth.id).setData(["name": name, "type": type, "image" : image, "temp": temp, "color": color, "isDefault": isDefault]) { error in
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

func labelSize(for text: String) -> CGSize {
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 17)
    ]

    let attributedText = NSAttributedString(string: text, attributes: attributes)

    let constraintBox = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

    let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral

    return rect.size
}

struct AddClothesView: View {
    @StateObject private var mainViewModel = MainScreenViewModel.shared
    @StateObject private var viewModel = AddClothesViewModel.shared
    @Environment(\.managedObjectContext) var managedObjectContext
    var isEdtitngCloth = false
    @Binding var isShowingSheet: Bool
    

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 32, height: 4)
                .padding(.top, 8)
                .foregroundColor(.gray)
            
            ScrollView (.vertical, showsIndicators: false) {
                VStack (alignment: .leading) {
                    Text(isEdtitngCloth ? "Edit item" : "Add item")
                        .font(.custom("Montserrat-SemiBold", size: 22))
                        .foregroundColor(Color(hex: "#646C75"))
                        .padding(.top, 24)
                        .padding(.horizontal, 24)
                    
                    InputNameView()
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    
                    AddPhotoView()
                        .padding(24)
                    
                    NewTagsView()
                        .padding(.horizontal, 24)
                    
                    NewChooseTempView()
                    
                    ChooseColorView()
                }
            }
            Spacer(minLength: 28)
            
            if isEdtitngCloth {
                Button {
                    let tempNames = getTemperatureNames(temp: viewModel.temp)
                    if !viewModel.cloth.isDefault {
                        if viewModel.imageId != "" {
                            viewModel.updateImage(imageId: viewModel.imageId)
                            viewModel.updateCloth(name: viewModel.cloth.name, image: viewModel.imageId, type: viewModel.cloth.type.rawValue, temp: tempNames, color: viewModel.cloth.color, isDefault: viewModel.cloth.isDefault)
                        } else {
                            viewModel.updateCloth(name: viewModel.cloth.name, image: viewModel.cloth.image, type: viewModel.cloth.type.rawValue, temp: tempNames, color: viewModel.cloth.color, isDefault: viewModel.cloth.isDefault)
                        }
                    } else if viewModel.cloth.isDefault {
                        viewModel.updateCloth(name: viewModel.cloth.name, image: viewModel.cloth.type.rawValue, type: viewModel.cloth.type.rawValue, temp: tempNames, color: viewModel.cloth.color, isDefault: viewModel.cloth.isDefault)
                    }
                    viewModel.reset()
                    isShowingSheet = false
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 56)
                        Text("SAVE")
                            .font(.custom("Montserrat-SemiBold", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(DefaultColorButtonStyle(color: "#678CD4", radius: 24))
                .disabled(viewModel.cloth.name.count > 2 &&
                          viewModel.cloth.type != .blank && viewModel.temp != [] ? false : true)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            } else {
                Button(action: {
                    // add new cloth function
                    let tempNames = getTemperatureNames(temp: viewModel.temp)
                    if !viewModel.cloth.isDefault {
                        viewModel.addImageToStorage(fileName: viewModel.cloth.id)
                        viewModel.addCloth(name: viewModel.cloth.name, image: viewModel.cloth.id, type: viewModel.cloth.type.rawValue, temp: tempNames, color: viewModel.cloth.color, isDefault: viewModel.cloth.isDefault)
                    } else if viewModel.cloth.isDefault {
                        viewModel.addCloth(name: viewModel.cloth.name, image: viewModel.cloth.type.rawValue, type: viewModel.cloth.type.rawValue, temp: tempNames, color: viewModel.cloth.color, isDefault: viewModel.cloth.isDefault)
                    }
                    viewModel.reset()
                    isShowingSheet = false
                }) {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(height: 56)
                        Text("SAVE")
                            .font(.custom("Montserrat-SemiBold", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(DefaultColorButtonStyle(color: "#678CD4", radius: 24))
                .disabled(viewModel.cloth.name.count > 2 &&
                          viewModel.cloth.type != .blank && viewModel.temp != [] ? false : true)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
    }
    
    func getTemperatureNames(temp: [Temperature]) -> [String] {
        var tempNames = [String]()
        for item in temp {
            tempNames.append(item.name)
        }
        return tempNames
    }
}
