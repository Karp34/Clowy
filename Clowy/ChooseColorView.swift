//
//  ChooseColorView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct ChooseColorView: View {
    let insets = EdgeInsets(top: 8, leading: 24, bottom: 2, trailing: 24)
    
    @State var chosenColor: String = ""
    
    var body: some View {
        VStack( alignment: .leading, spacing:0) {
            Text("Color")
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#646C75"))
                .padding(.horizontal, 24)
                .padding(.top, 24)
            
            let colorList: [[String]] = [["#A5D469", "#C6FF7E", "#7DA150"], ["#EAAF2D", "#FE9011"], ["#89112C"], ["#FFFFFF"]]
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack (spacing: 8) {
                    ForEach(colorList, id: \.self) { id in
                        if !id.isEmpty {
                            if id.contains(chosenColor) {
                                ChosenColor(colorList: id, chosenColor: chosenColor)
                            } else {
                                if id.first == "#FFFFFF" {
                                    Circle()
                                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                                        .foregroundColor(Color(hex: id.first!))
                                        .frame(width: 32, height: 32)
                                        .onTapGesture {
                                            withAnimation{
                                                chosenColor = id.first!
                                            }
                                        }
                                } else {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(Color(hex: id.first!))
                                        .onTapGesture {
                                            withAnimation{
                                                chosenColor = id.first!
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
                .frame(height: 40)
                .padding(insets)
            }
        }
    }
}

struct ChosenColor: View {
    var colorList: [String]
    @State var chosenColor: String
    
    var body: some View {
        if colorList.count > 1 {
            ZStack {
                HStack(spacing: 4) {
                    ForEach(colorList, id:\.self) { color in
                        if color == chosenColor {
                            if color == "#FFFFFF" {
                                ZStack {
                                    Circle()
                                        .stroke(.gray, style: StrokeStyle(lineWidth: 1))
                                        .foregroundColor(.red)
                                        .frame(width: 32, height: 32)
                                    Image("Ok")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.black)
                                        .frame(width: 20, height: 20)
                                }
                                .onTapGesture {
                                    withAnimation {
                                        chosenColor = ""
                                    }
                                }
                            } else {
                                ZStack {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(Color(hex: color))
                                    Image("Ok")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(Color(hex: "#FFFFFF"))
                                }
                                .onTapGesture {
                                    withAnimation {
                                        chosenColor = ""
                                    }
                                }
                            }
                        } else {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color(hex: color))
                                .onTapGesture {
                                    withAnimation {
                                        chosenColor = color
                                    }
                                }
                        }
                    }
                }
                .padding(4)
                .background((Color(hex: "#FFFFFF")))
                .clipShape(RoundedRectangle(cornerRadius: 40))
            }
        } else {
            ForEach(colorList, id:\.self) { color in
                ZStack {
                        Circle()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(hex: color))
                    if color == "#FFFFFF" {
                        ZStack {
                            Circle()
                                .stroke(.gray, style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(.red)
                                .frame(width: 32, height: 32)
                            Image("Ok")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.black)
                                .frame(width: 20, height: 20)
                        }
                        .onTapGesture {
                            withAnimation {
                                chosenColor = ""
                            }
                        }
                    } else {
                        ZStack {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color(hex: color))
                            Image("Ok")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color(hex: "#FFFFFF"))
                        }
                        .onTapGesture {
                            withAnimation {
                                chosenColor = ""
                            }
                        }
                    }
                }
            }
        }
    }
}
//
//struct ChooseColorView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChooseColorView()
//    }
//}
