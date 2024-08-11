//
//  ProfileNavBarContent.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.08.2022.
//

import SwiftUI
import Combine

class ProfileNavBarContentViewModel: ObservableObject {
    @Published var image: Data = .init(count: 0)
    static var shared = ProfileNavBarContentViewModel()
}

struct ProfileNavBarContent: View {
    @StateObject private var viewModel = ProfileNavBarContentViewModel.shared
    @StateObject var mainViewModel = MainScreenViewModel.shared
    @Environment(\.managedObjectContext) var moc
    @State var show = false
    @State private var isActionSheetPresented = false
    
    @State var isChangingImage = false
    
    @State var isChangingName = false
    var color = "#CEDAE1"
    
    let hint = "Your name"
    @FocusState private var isTextFieldFocused: Bool
    
    let insets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    let textLimit = 16
    
    func limitText(_ upper: Int) {
        if mainViewModel.user.username.count > upper {
            mainViewModel.user.username = String(mainViewModel.user.username.prefix(upper))
        }
    }
    
    func saveChanges() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isChangingName = false
            isChangingImage = false
            isTextFieldFocused = false
        }
    }
    
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color(hex: "#678CD4"))
                .onTapGesture {
                    withAnimation {
                        saveChanges()
                        mainViewModel.updateUser { _ in }
                    }
                }
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .frame(width: isChangingName ? 96 : 72, height: isChangingName ? 96 : 72)
                        .foregroundColor(Color(hex: color))
                    Image(mainViewModel.user.userIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: isChangingName ? 67 : (mainViewModel.user.userIcon.starts(with: "memoji") ? 62 : 50), height: isChangingName ? 67 : (mainViewModel.user.userIcon.starts(with: "memoji") ? 62 : 50))
                }
                .padding(.top, isChangingName ? 56 : 8)
                .onTapGesture {
                    if isChangingName == false {
                        withAnimation(.easeInOut(duration: 1)) {
                            isChangingImage.toggle()
                        }
                    } else {
                        withAnimation {
                            saveChanges()
                            mainViewModel.updateUser { _ in }
                        }
                    }
                }
                VStack(spacing: 0) {
                    ZStack {
                        if isChangingName {
                            if mainViewModel.user.username.trimmingCharacters(in: .whitespaces).count < 1 {
                                Text(hint)
                                    .foregroundColor(Color(hex: "##FFFFFF"))
                                    .multilineTextAlignment(.center)
                                    .opacity(0.5)
                                    .font(.custom("Montserrat-Semibold", size: 32))
                                    .padding(.top, 83)
                            }
                            TextField("", text: $mainViewModel.user.username)
                                .textFieldStyle(CustomFieldStyle2(isFocused: isChangingName))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 38)
                                .padding(.top, 83)
                                .focused($isTextFieldFocused)
                                .onSubmit {
                                    saveChanges()
                                    mainViewModel.updateUser { _ in }
                                }
                        } else {
                            Text(mainViewModel.user.username)
                                .padding(.bottom, 16)
                                .foregroundColor(Color(hex: "##FFFFFF"))
                                .multilineTextAlignment(.center)
                                .font(.custom("Montserrat-Semibold", size: 20))
                                .onTapGesture {
                                    if !isChangingImage {
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            isChangingName.toggle()
                                            isTextFieldFocused = true
                                        }
                                    }
                                }
                        }
                        
                    }
                    
                    if isChangingName {
                        Spacer()
                    }
                }
            }
            
            if isChangingImage == true {
                let emojiList = GetEmojis.getEmojis()
                
                ZStack {
                    Rectangle()
                        .frame(width: 11, height: 11)
                        .foregroundColor(.white)
                        .rotationEffect(Angle.degrees(45))
                        .padding(.bottom, 60)
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 64)
                            .foregroundColor(.white)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (spacing: 8) {
                                Button {
                                    isActionSheetPresented.toggle()
                                } label: {
                                    ZStack {
                                        Circle()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(Color(hex: "#E1E8F6"))
                                        Image(systemName: "camera.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 18)
                                            .foregroundColor(Color(hex: "#678CD4"))
                                    }
                                }
                                .actionSheet(isPresented: $isActionSheetPresented) {
                                    ActionSheet(title: Text("Take a picture or choose from library"), buttons: [
                                        .cancel(),
                                        .default(
                                            Text("Take a picture"),
                                            action: {
                                                show.toggle()
                                            }
                                        ),
                                        .default(
                                            Text("Choose from library"),
                                            action: {
                                                show.toggle()
                                            }
                                        )
                                    ])
                                }
                                
                                
                                ForEach(emojiList, id:\.self) { emoji in
                                    ZStack {
                                        if mainViewModel.user.userIcon != emoji.icon {
                                            Circle()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color(hex: emoji.color))
                                            Image(emoji.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: (emoji.icon.starts(with: "memoji") ? 35 : 28), height: (emoji.icon.starts(with: "memoji") ? 35 : 28))
                                        } else {
                                            Circle()
                                                .stroke(Color(hex: "#9FA8AD"), style: StrokeStyle(lineWidth: 1))
                                                .background(Circle().foregroundColor(Color(hex: emoji.color)))
                                                .frame(width: 40, height: 40)
                                            
                                            Image(emoji.icon)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: (emoji.icon.starts(with: "memoji") ? 35 : 28), height: (emoji.icon.starts(with: "memoji") ? 35 : 28))
                                            
                                            HStack {
                                                Spacer()
                                                VStack{
                                                    ZStack {
                                                        Circle()
                                                            .foregroundColor(.green)
                                                            .frame(width: 12, height: 12)
                                                        Image("Ok")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .foregroundColor(.white)
                                                            .frame(width: 7, height: 6)
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: 40, height: 42)
                                    .onTapGesture {
                                        withAnimation(.easeInOut) {
                                            mainViewModel.user.userIcon = emoji.icon
                                        }
                                    }
                                }
                            }
                            .padding(insets)
                        }
                    }
                    
                }
                .offset(y: 56)
                .padding(.horizontal, 24)
                .shadow(color: Color(hex: "#273145").opacity(0.2), radius: 35, x: 0, y: 8)
            }
        }
        .frame(height: isChangingName ? nil : 120)
        .edgesIgnoringSafeArea(.all)
    }
}
