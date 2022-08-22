//
//  WardrobeScreenView.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.12.2021.
//

import SwiftUI

class WardrobeScreenViewModel: ObservableObject {
}



struct WardrobeScreenView: View{
    
    @State private var isShowingSheet = false
    @ObservedObject private var viewModel = WardrobeScreenViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var clothes: [Wardrobe] = []
    private func getClothes() {
        let resultClothes = GetClothes.getClothes()
        clothes = resultClothes
    }
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.font : UIFont(name: "Montserrat-Bold", size: 14)!]
        if #available(iOS 14.0, *) {
            UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Montserrat-Bold", size: 14)!, .foregroundColor: UIColor(Color(hex: "#FFFFFF"))]
            navBarAppearance.backgroundColor = UIColor(Color(hex: "#F7F8FA"))
        }
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    
    }
    
    var btnAdd : some View {
        Button(action: {
            isShowingSheet.toggle()
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                Image(systemName: "plus")
                    .foregroundColor(Color(hex: "#646C75"))
                    .frame(width: 32.0, height: 32.0)
            }
        }
        .sheet(isPresented: $isShowingSheet, onDismiss: didDismiss) {
            VStack (spacing: 0) {
                AddClothesView(isShowingSheet: $isShowingSheet)
                Button(action: {
                    isShowingSheet.toggle()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .frame(height: 56)
                            .foregroundColor(Color(hex: "#CBCED2"))
                        Text("SAVE")
                            .font(.custom("Montserrat-SemiBold", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }
    
    var btnBack : some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()}) {
                Image("back_button")
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 12.0).contentShape(Rectangle())
                    .foregroundColor(.black)
            }
    }

    var body: some View {
        ScrollView  (.vertical, showsIndicators: false){
            VStack (alignment: .leading){
                Spacer(minLength: 24)
                ForEach(0..<21) { id in
                    ForEach(clothes) { cloth in
                        if id == cloth.id.rawValue {
                            if !cloth.items.isEmpty {
                                WardrobeClothesCardCollection(name: cloth.clothesTypeName.rawValue, clothes: cloth.items)
                            } else {
                                NoClothesCollection(name: cloth.clothesTypeName.rawValue)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationBarItems(leading: btnBack, trailing: btnAdd)
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            getClothes()
        }
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
    }
    func didDismiss() {
        // Handle the dismissing action.
    }
}
