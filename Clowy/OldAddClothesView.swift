////
////  AddClothesView.swift
////  MyCombineProject
////
////  Created by Егор Карпухин on 18.01.2022.
////
//
//import SwiftUI
//
//class AddClothesViewModel: ObservableObject {
//    
//    @Published var id: Int = 0
//    @Published var name: String = ""
//    @Published var clothesType: String = ""
//    @Published var temp: [Temperature] = []
//    @Published var color: String? = nil
//    @Published var image: Data = .init(count: 0)
//    @Published var chosenColor: String = "#FFFFFF"
//    @Published var isDefault: Bool = false
//    
//    static var shared = AddClothesViewModel()
//
//    func reset() {
//        id = 0
//        name = ""
//        clothesType = ""
//        temp = []
//        color = nil
//        image = .init(count: 0)
//        chosenColor = "#FFFFFF"
//        isDefault = false
//    }
//    
//    func createTempNames() -> [String] {
//        
//        var tempNames: [String] = []
//        for item in temp {
//            tempNames.append(item.name)
//        }
//        return tempNames
//    }
//}
//
//func labelSize(for text: String) -> CGSize {
//    let attributes: [NSAttributedString.Key: Any] = [
//        .font: UIFont.systemFont(ofSize: 17)
//    ]
//
//    let attributedText = NSAttributedString(string: text, attributes: attributes)
//
//    let constraintBox = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
//
//    let rect = attributedText.boundingRect(with: constraintBox, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).integral
//
//    return rect.size
//}
//
//struct AddClothesView: View {
//    
//    @StateObject private var viewModel = AddClothesViewModel.shared
//    @Environment(\.managedObjectContext) var managedObjectContext
//    
//    @FetchRequest(
//        entity: TestWardrobe.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \TestWardrobe.name, ascending: true)]
//    ) var categories: FetchedResults<TestWardrobe>
//    
//    @Binding var isShowingSheet: Bool
//    
//
//    var body: some View {
//        VStack(spacing: 0) {
//            RoundedRectangle(cornerRadius: 5)
//                .frame(width: 32, height: 4)
//                .padding(.top, 8)
//                .foregroundColor(.gray)
//            
//            ScrollView (.vertical, showsIndicators: false) {
//                VStack (alignment: .leading) {
//                    InputNameView(viewModel: viewModel)
//                        .padding(.horizontal, 24)
//                        .padding(.top, 12)
//                    AddPhotoView(viewModel: viewModel)
//                        .padding(24)
//                    
//                    
//                    NewTagsView(viewModel: viewModel)
//                        .padding(.horizontal, 24)
//                    
//                    NewChooseTempView(viewModel: viewModel)
//                    
//                    ChooseColorView()
//                }
//            }
//            Spacer(minLength: 28)
//            
//            Button(action: {
//                for category in categories {
//                    if viewModel.clothesType == category.name {
//                        let clothes = TestCloth(context: managedObjectContext)
//                        clothes.id = UUID()
//                        clothes.clothesType = viewModel.clothesType
//                        clothes.name = viewModel.name
//                        clothes.temp = viewModel.createTempNames()
//                        clothes.toTestWardrobe = category
//                        clothes.image = viewModel.image
//                        clothes.color = viewModel.chosenColor
//                        clothes.isDefault = viewModel.isDefault
//                        PersistenceController.shared.save()
//
//
//                    } else {
//
//                    }
//                }
//                viewModel.reset()
//                isShowingSheet = false
//            }) {
//                ZStack {
//                    Rectangle()
//                        .foregroundColor(.clear)
//                        .frame(height: 56)
//                    Text("SAVE")
//                        .font(.custom("Montserrat-SemiBold", size: 16))
//                        .foregroundColor(.white)
//                }
//            }
//            .buttonStyle(DefaultColorButtonStyle(color: "#678CD4", radius: 24))
//            .disabled(viewModel.name.count > 2 && viewModel.image != .init(count: 0) && viewModel.clothesType != "" && viewModel.temp != [] ? false : true)
//            .padding(.horizontal, 24)
//            .padding(.bottom, 40)
//        }
//        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
//    }
//}
