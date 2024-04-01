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
    @Environment(\.managedObjectContext) var moc
    @State var show = false
    @State private var isActionSheetPresented = false
    
    @State var isChangingImage = false
    
    @State var isChangingName = false
    var color = "#CEDAE1"
    
    let hint = "Enter your name"
    @State var username = UserDefaults.standard.string(forKey: "username")!.trimmingCharacters(in: .whitespaces) ?? "Username"
    
    @State var avatar = UserDefaults.standard.string(forKey: "avatar") ?? "Panda"
    
    let insets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    let textLimit = 16
    
    func limitText(_ upper: Int) {
        if username.count > upper {
            username = String(username.prefix(upper))
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color(hex: "#678CD4"))
                .onTapGesture {
                    withAnimation {
                        if username.trimmingCharacters(in: .whitespaces).count > 0 {
                            UserDefaults.standard.set(username.trimmingCharacters(in: .whitespaces), forKey: "username")
                        }
                        isChangingName = false
                        isChangingImage = false
                    }
                }
            VStack {
                ZStack {
                    Circle()
                        .frame(width: isChangingName ? 96 : 72, height: isChangingName ? 96 : 72)
                        .foregroundColor(Color(hex: color))
                    Image(avatar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: isChangingName ? 67 : (avatar.starts(with: "memoji") ? 62 : 50), height: isChangingName ? 67 : (avatar.starts(with: "memoji") ? 62 : 50))
                }
                .padding(.top, isChangingName ? 56 : 8)
                .onTapGesture {
                    if isChangingName == false {
                        withAnimation {
                            isChangingImage.toggle()
                        }
                    }
                }
                if isChangingName == true {
                    VStack {
                        ZStack {
                            if username.trimmingCharacters(in: .whitespaces).count < 1 {
                                Text(hint)
                                    .foregroundColor(Color(hex: "##FFFFFF"))
                                    .multilineTextAlignment(.center)
                                    .opacity(0.5)
                                    .font(.custom("Montserrat-Semibold", size: 32))
                            }
                            
                            TextField("", text: $username, onEditingChanged: { (isChangingName) in
                                if username.trimmingCharacters(in: .whitespaces).count > 0  && username.starts(with: " ") == false {
                                    UserDefaults.standard.set(username.trimmingCharacters(in: .whitespaces), forKey: "username")
                                }
                            }, onCommit: {
                                withAnimation {
                                    if username.trimmingCharacters(in: .whitespaces).count > 0  && username.starts(with: " ") == false {
                                        UserDefaults.standard.set(username.trimmingCharacters(in: .whitespaces), forKey: "username")
                                    }
                                    isChangingName = false
                                }
                            })
                                .textFieldStyle(CustomFieldStyle2())
                                .multilineTextAlignment(.center)
                                .onReceive(Just(username)) { _ in limitText(textLimit) }
                            
                            
                            
                        }
                        .padding(.horizontal)
                        .padding(.top, 83)
                        Spacer()
                    }
                } else {
                    Text(username)
                        .font(.custom("Montserrat-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                        .onTapGesture {
                            withAnimation {
                                isChangingName.toggle()
                            }
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
                                        if avatar != emoji.icon {
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
                                        withAnimation {
                                            UserDefaults.standard.set(emoji.icon, forKey: "avatar")
                                            avatar = emoji.icon
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
        .frame(height: isChangingName ? nil : 114)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProfileNavBarContent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileNavBarContent()
    }
}
