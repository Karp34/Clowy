////
////  ChooseColorView.swift
////  MyCombineProject
////
////  Created by Егор Карпухин on 19.01.2022.
////
//
//import SwiftUI
//
//struct ChooseColorView: View {
//    @StateObject private var viewModel = AddClothesViewModel.shared
//    let insets = EdgeInsets(top: 8, leading: 24, bottom: 2, trailing: 24)
//    
//    var body: some View {
//        VStack( alignment: .leading, spacing:0) {
//            Text("Color")
//                .font(.custom("Montserrat-SemiBold", size: 16))
//                .foregroundColor(Color(hex: "#646C75"))
//                .padding(.horizontal, 24)
//                .padding(.top, 24)
//            
//            let colorList: [[String]] = [
//                ["#FFFFFF"], //white
//                ["#323232", "#808080", "#CCCCCC"], //black
//                ["#806030", "#CC9A4D", "#E0C49A"], //brown
//                ["#A60000", "#D90000", "#FF7777"], //red
//                ["#D97500", "#FDBF1F", "#FFBE5B"], //orange
//                ["#E5CF00", "#FFE600", "#FFF27A"], //yellow
//                ["#137016", "#1BA320", "#55DA5A"], //green
//                ["#0070C0", "#00B0F0", "#8AE0FF"], //blue
//                ["#380094", "#8236FF", "#B283FF"], //purple
//                ["#EF32FF", "#F68EFF", "#FAC2FF"] //pink
//            ]
//            
//            ScrollView (.horizontal, showsIndicators: false) {
//                HStack (spacing: 8) {
//                    ForEach(colorList, id: \.self) { id in
//                        if !id.isEmpty {
//                            if id.contains(viewModel.chosenColor) {
//                                ChosenColorView(colorList: id)
//                            } else {
//                                if id.first == "#FFFFFF" {
//                                    Circle()
//                                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
//                                        .foregroundColor(Color(hex: id.first!))
//                                        .frame(width: 32, height: 32)
//                                        .onTapGesture {
//                                            withAnimation{
//                                                viewModel.chosenColor = id.first!
//                                            }
//                                        }
//                                } else {
//                                    Circle()
//                                        .frame(width: 32, height: 32)
//                                        .foregroundColor(Color(hex: id.first!))
//                                        .onTapGesture {
//                                            withAnimation {
//                                                viewModel.chosenColor = id.first!
//                                            }
//                                        }
//                                }
//                            }
//                        }
//                    }
//                }
//                .frame(height: 40)
//                .padding(insets)
//            }
//        }
//    }
//}
//
//struct ChosenColorView: View {
//    var colorList: [String]
//    @StateObject private var viewModel = AddClothesViewModel.shared
//    
//    var body: some View {
//        if colorList.count > 1 {
//            ZStack {
//                HStack(spacing: 4) {
//                    ForEach(colorList, id:\.self) { color in
//                        if color == viewModel.chosenColor {
//                            if color == "#FFFFFF" {
//                                ZStack {
//                                    Circle()
//                                        .stroke(.gray, style: StrokeStyle(lineWidth: 1))
//                                        .foregroundColor(.red)
//                                        .frame(width: 32, height: 32)
//                                    Image("Ok")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .foregroundColor(.black)
//                                        .frame(width: 20, height: 20)
//                                }
//                                .onTapGesture {
//                                    withAnimation {
//                                        viewModel.chosenColor = "#FFFFFF"
//                                    }
//                                }
//                            } else {
//                                ZStack {
//                                    Circle()
//                                        .frame(width: 32, height: 32)
//                                        .foregroundColor(Color(hex: color))
//                                    Image("Ok")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .frame(width: 20, height: 20)
//                                        .foregroundColor(Color(hex: "#FFFFFF"))
//                                }
//                                .onTapGesture {
//                                    withAnimation {
//                                        viewModel.chosenColor = color
//                                    }
//                                }
//                            }
//                        } else {
//                            Circle()
//                                .frame(width: 32, height: 32)
//                                .foregroundColor(Color(hex: color))
//                                .onTapGesture {
//                                    withAnimation {
//                                        viewModel.chosenColor = color
//                                    }
//                                }
//                        }
//                    }
//                }
//                .padding(4)
//                .background((Color(hex: "#FFFFFF")))
//                .clipShape(RoundedRectangle(cornerRadius: 40))
//            }
//        } else {
//            ForEach(colorList, id:\.self) { color in
//                ZStack {
//                        Circle()
//                            .frame(width: 32, height: 32)
//                            .foregroundColor(Color(hex: color))
//                    if color == "#FFFFFF" {
//                        ZStack {
//                            Circle()
//                                .stroke(.gray, style: StrokeStyle(lineWidth: 1))
//                                .foregroundColor(.red)
//                                .frame(width: 32, height: 32)
//                            Image("Ok")
//                                .resizable()
//                                .scaledToFit()
//                                .foregroundColor(.black)
//                                .frame(width: 20, height: 20)
//                        }
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.chosenColor = "#FFFFFF"
//                            }
//                        }
//                    } else {
//                        ZStack {
//                            Circle()
//                                .frame(width: 32, height: 32)
//                                .foregroundColor(Color(hex: color))
//                            Image("Ok")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 20, height: 20)
//                                .foregroundColor(Color(hex: "#FFFFFF"))
//                        }
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.chosenColor = color
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
