//
//  ChooseTempView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct NewChooseTempView: View {
    @ObservedObject var viewModel = AddClothesViewModel.shared
    
    let insets = EdgeInsets(top: 8, leading: 24, bottom: 0, trailing: 24)
    
    let tempLists = [
        Temperature(id: 0, name: TemperatureType.superCold.rawValue, temp: [-30, -20]),
        Temperature(id: 1, name: TemperatureType.cold.rawValue, temp: [-20, -10]),
        Temperature(id: 2, name: TemperatureType.coldy.rawValue, temp: [-10, -5]),
        Temperature(id: 3, name: TemperatureType.cool.rawValue, temp: [-5, 5]),
        Temperature(id: 4, name: TemperatureType.regular.rawValue, temp: [5, 15]),
        Temperature(id: 5, name: TemperatureType.warm.rawValue, temp: [15, 25]),
        Temperature(id: 6, name: TemperatureType.hot.rawValue, temp: [25, 35])
        ]
    
    
    
    
    var body: some View {
        VStack( alignment: .leading, spacing:0) {
            Text("Temperature")
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#646C75"))
                .padding(.horizontal, 24)
                .padding(.top, 24)
 
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack (spacing: 4 ) {
                    ForEach(tempLists) { id in
                        if viewModel.temp.contains(id) {
                            TemperatureView(tempList: id.temp, backColor: "#678CD4", textColor: "#FFFFFF")
                                .onTapGesture {
                                    if let i = viewModel.temp.firstIndex(of: id) {
                                        viewModel.temp.remove(at: i)
                                        print(viewModel.temp)
                                    }
                                }
                        } else {
                            TemperatureView(tempList: id.temp, backColor: "#EFF0F2", textColor: "#646C75")
                                .onTapGesture {
                                    viewModel.temp.append(id)
                                    print(viewModel.cloth.temperature)
                                }
                        }
                    }
                }
                .padding(insets)
            }
        }
    }
}
