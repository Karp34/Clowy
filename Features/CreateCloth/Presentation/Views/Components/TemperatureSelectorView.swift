//
//  ChooseTempView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct TemperatureSelectorView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel
    
    let insets = EdgeInsets(top: 8, leading: 24, bottom: 0, trailing: 24)
    let tempLists = GetTemperatureRange.getTemperatureList()
    
    var body: some View {
        VStack( alignment: .leading, spacing:0) {
            Text("Temperature")
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color.primaryGrey)
                .padding(.horizontal, 24)
                .padding(.top, 24)
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack (spacing: 4 ) {
                    ForEach(tempLists) { id in
                        if viewModel.temp.contains(id) {
                            TemperatureView(tempList: id.temp, backColor: Color.primaryBlueBrand, textColor: Color.white)
                                .onTapGesture {
                                    if let i = viewModel.temp.firstIndex(of: id) {
                                        viewModel.temp.remove(at: i)
                                    }
                                }
                        } else {
                            TemperatureView(tempList: id.temp, backColor: Color.secondaryGrey, textColor: Color.primaryGrey)
                                .onTapGesture {
                                    viewModel.temp.append(id)
                                }
                        }
                    }
                }
                .padding(insets)
            }
        }
    }
}
