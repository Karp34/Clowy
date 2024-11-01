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
    
    let tempLists = GetTemperatureRange.getTemperatureList()
    
    
    
    
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
