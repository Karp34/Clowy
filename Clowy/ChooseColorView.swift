//
//  ChooseColorView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct ChooseColorView: View {
    @StateObject private var viewModel = AddClothesViewModel.shared
    let insets = EdgeInsets(top: 8, leading: 24, bottom: 2, trailing: 24)
    
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
                            if id.contains(viewModel.chosenColor) {
                                ChosenColorView(colorList: id)
                            } else {
                                if id.first == "#FFFFFF" {
                                    Circle()
                                        .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                                        .foregroundColor(Color(hex: id.first!))
                                        .frame(width: 32, height: 32)
                                        .onTapGesture {
                                            withAnimation{
                                                viewModel.chosenColor = id.first!
                                            }
                                        }
                                } else {
                                    Circle()
                                        .frame(width: 32, height: 32)
                                        .foregroundColor(Color(hex: id.first!))
                                        .onTapGesture {
                                            withAnimation {
                                                viewModel.chosenColor = id.first!
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

struct ChosenColorView: View {
    var colorList: [String]
    @StateObject private var viewModel = AddClothesViewModel.shared
    
    var body: some View {
        if colorList.count > 1 {
            ZStack {
                HStack(spacing: 4) {
                    ForEach(colorList, id:\.self) { color in
                        if color == viewModel.chosenColor {
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
                                        viewModel.chosenColor = "#FFFFFF"
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
                                        viewModel.chosenColor = color
                                    }
                                }
                            }
                        } else {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color(hex: color))
                                .onTapGesture {
                                    withAnimation {
                                        viewModel.chosenColor = color
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
                                viewModel.chosenColor = "#FFFFFF"
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
                                viewModel.chosenColor = color
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

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
