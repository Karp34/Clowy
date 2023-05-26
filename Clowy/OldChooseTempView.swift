////
////  ChooseTempView.swift
////  MyCombineProject
////
////  Created by Егор Карпухин on 19.01.2022.
////
//
//import SwiftUI
//
//struct ChooseTempView: View {
//    let insets = EdgeInsets(top: 8, leading: 24, bottom: 0, trailing: 24)
//    @State var chosenWeather: [[Int]] = []
//    
//    var body: some View {
//        VStack( alignment: .leading, spacing:0) {
//            Text("Temperature")
//                .font(.custom("Montserrat-SemiBold", size: 16))
//                .foregroundColor(Color(hex: "#646C75"))
//                .padding(.horizontal, 24)
//                .padding(.top, 24)
//            
//            let tempLists = [[-30, -20], [-20, -10], [-10, 0], [0, 10], [10, 20], [20, 30]]
//            ScrollView (.horizontal, showsIndicators: false) {
//                HStack (spacing: 4) {
//                    ForEach(tempLists, id: \.self) { id in
//                        if chosenWeather.contains(id) {
//                            TemperatureView(tempList: id, backColor: "#678CD4", textColor: "#FFFFFF")
//                                .onTapGesture {
//                                    let index = chosenWeather.firstIndex(where: {$0 == id} )
//                                    chosenWeather.remove(at: (index)!)
//                                }
//                        } else {
//                            TemperatureView(tempList: id, backColor: "#EFF0F2", textColor: "#646C75")
//                                .onTapGesture {
//                                    chosenWeather.append(id)
//                                }
//                        }
//                    }
//                }
//                .padding(insets)
//            }
//        }
//    }
//}
//
//struct ChooseTempView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseTempView()
//    }
//}
