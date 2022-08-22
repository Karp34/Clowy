//
//  WardrobeView.swift
//  Clowy
//
//  Created by Егор Карпухин on 28.06.2022.
//


import SwiftUI
import AVFAudio

class WardrobeCoreDataViewModel: ObservableObject {
}



struct WardrobeCoreDataView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @FetchRequest(
        entity: TestCloth.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestCloth.name, ascending: true)]
    ) var items: FetchedResults<TestCloth>
    
    @FetchRequest(
        entity: TestWardrobe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestWardrobe.id, ascending: true)]
    ) var categories: FetchedResults<TestWardrobe>
    
    
    @State private var isShowingSheet = false
    @ObservedObject private var viewModel = WardrobeScreenViewModel()
    
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
            VStack {
                Spacer(minLength: 24)
                
                ForEach (categories) { category in
                    if category.name != nil {
                        if category.toTestCloth != nil {
                            let clothesArray = Array(category.toTestCloth as! Set<TestCloth>)
                            
                            if category.toTestCloth!.count > 0 {
                                WardrobeClothesTestCardCollection(name: category.name!, clothes: clothesArray)
                            } else {
                                NoClothesCollection(name: category.name!)
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
