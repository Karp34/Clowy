//
//  WardrobeScreenView.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.12.2021.
//

import SwiftUI
import WaterfallGrid

struct NewOutfitScreen: View {
    @State private var isShowingSheet = false
    @State private var isPresented = false
    @StateObject private var viewModel = MainScreenViewModel.shared
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnAdd : some View {
        Button {
            isPresented.toggle()
        } label: {
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.white)
                Image(systemName: "plus")
                    .foregroundColor(Color(hex: "#646C75"))
                    .frame(width: 32.0, height: 32.0)
            }
        }
    }
    
    var btnBack : some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()}) {
                Image("back_button")
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 12.0)
                    .padding(.leading, 8)
                    .foregroundColor(.black)
            }
    }
    
    var body: some View {
        VStack {
            if viewModel.outfitState == .success {
                if viewModel.outfits.isEmpty {
                    NoItemsOutfitScreen()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 16) {
//                            viewModel.outfits = viewModel.outfits.sorted(by: { ($0.createDTM ?? 0) > ($1.createDTM ?? 0) } )
                            let sortedOutfits = viewModel.outfits.sorted {
                                $0.createDTM ?? 0 < $1.createDTM ?? 0
                            }
                            ForEach(sortedOutfits) { outfit in
                                if outfit.clothes.count > 0 {
                                    VStack (alignment: .leading, spacing: 16) {
                                        HStack {
                                            Text(outfit.name)
                                                .font(.custom("Montserrat-SemiBold", size: 22))
                                                .padding(.leading, 24)
                                                .foregroundColor(Color(hex: "#646C75"))
                                            Spacer()
//                                            NavigationLink(
//                                                destination:
//                                                    AddNewOutfitView(newOutfit: outfit.outfit)
//                                            ) {
//                                                Image("Edit")
//                                                    .resizable()
//                                                    .foregroundColor(Color(hex: "#646C75"))
//                                                    .frame(width: 16, height: 16)
//                                                    .scaledToFit()
//                                                    .padding(.trailing,16)
                                            }
                                        OutfitView(outfit: outfit.clothes, isEditing: false)
                                    }
                                }
                            }
                            .onAppear {
                                print( sortedOutfits)
                                print(viewModel.outfits)
                            }
                        }
                    }
                }
            } else if viewModel.outfitState == .error {
                ErrorOutfitScreen()
            } else if viewModel.outfitState == .placeholder {
                OutfitScreenPlaceholder()
                    .onAppear {
                        viewModel.fetchOutfits()
                    }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarItems(leading: btnBack, trailing: btnAdd)
        .navigationBarBackButtonHidden(true)
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
        .fullScreenCover(isPresented: $isPresented) {
            AddNewOutfitView()
        }
    }
    
    func didDismiss() {
        // Handle the dismissing action.
    }
}
