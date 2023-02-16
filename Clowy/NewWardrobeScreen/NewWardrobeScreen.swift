//
//  WardrobeView.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 02.10.2022.
//

import SwiftUI

struct NewWardrobeScreen: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isShowingSheet = false
    
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
            }
        }
    }
    
    var btnBack : some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()}) {
                Image("back_button")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12, height: 12.0).contentShape(Rectangle())
                    .foregroundColor(.black)
            }
    }
    
    var body: some View {
        ScrollView  (.vertical, showsIndicators: false) {
            if viewModel.wardrobe.isEmpty {
                NewWardrobeScreenPlaceholder()
                    .onAppear {
                        print("Here")
                        viewModel.fetchWardrobe()
                    }
            } else {
                VStack {
                    ForEach(viewModel.wardrobe) { cat in
                        if cat.items.count > 0 {
                            ClothesCollectionView(name: cat.clothesTypeName.rawValue, clothes: cat.items)
                        } else {
                            NoClothesCollection(name: cat.clothesTypeName.rawValue)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
//        .onAppear {
//            viewModel.wardrobe.removeAll()
//        }
        .navigationBarTitle("My Wardrobe")
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: btnBack, trailing: btnAdd)
        .navigationBarBackButtonHidden(true)
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
    }
    func didDismiss() {
//        viewModel.reset()
    }
}
