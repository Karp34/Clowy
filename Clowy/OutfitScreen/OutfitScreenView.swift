//
//  WardrobeScreenView.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.12.2021.
//

import SwiftUI

class OutfitScreenViewModel: ObservableObject {

}
struct OutfitScreenView: View {
    @State private var isShowingSheet = false
    @ObservedObject private var viewModel = WardrobeScreenViewModel()
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var btnAdd : some View {
        NavigationLink(destination: AddNewOutfitView()) {
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
    
    @State var outfits: [Outfit] = []
    private func getOutfits() {
        let resultOutfits = GetOutfits.getOutfits()
        outfits = resultOutfits
    }
    
    var body: some View {
        ScrollView  (.vertical, showsIndicators: false){
            VStack (alignment: .leading){
                Spacer(minLength: 24)
                ForEach(outfits) { outfit in
                    if outfit.outfit.count > 0 {
                        VStack (alignment: .leading, spacing: 16) {
                            HStack {
                                Text("Outfit " + String(outfit.id+1))
                                    .font(.custom("Montserrat-SemiBold", size: 22))
                                    .padding(.leading)
                                    .foregroundColor(Color(hex: "#646C75"))
                                Spacer()
                                NavigationLink(
                                    destination: AddNewOutfitView(newOutfit: outfit.outfit)) {
                                    Image("Edit")
                                        .resizable()
                                        .foregroundColor(Color(hex: "#646C75"))
                                        .frame(width: 16, height: 16)
                                        .scaledToFit()
                                        .padding(.trailing,16)
                                }
                            }
                            
                            OutfitView(outfit: outfit.outfit, isEditing: false)
                        }
                        
                    }
                }
                .padding(.bottom, 16)
            }
        }
        
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarItems(leading: btnBack, trailing: btnAdd)
        .navigationBarBackButtonHidden(true)
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
        .onAppear() {
            getOutfits()
        }    }
    func didDismiss() {
        // Handle the dismissing action.
    }
}

struct OutfitView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitScreenView()
            .previewDevice("iPhone 12 mini")
    }
}
