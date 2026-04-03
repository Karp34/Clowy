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
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State var show = false
    @State private var isActionSheetPresented = false
    @State var isChangingImage = false
    @State var isChangingName = false
    @FocusState private var isTextFieldFocused: Bool

    var color = "#CEDAE1"
    let hint = "Your name"
    let insets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

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
                .foregroundColor(Color.primaryBlueBrand)
                .onTapGesture {
                    withAnimation {
                        saveChanges()
                        Task { await profileViewModel.updateUser() }
                    }
                }

            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .frame(width: isChangingName ? 96 : 72, height: isChangingName ? 96 : 72)
                        .foregroundColor(Color(hex: color))
                    Image(profileViewModel.user.userIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(
                            width: isChangingName ? 67 : (profileViewModel.user.userIcon.starts(with: "memoji") ? 62 : 50),
                            height: isChangingName ? 67 : (profileViewModel.user.userIcon.starts(with: "memoji") ? 62 : 50)
                        )
                }
                .padding(.top, isChangingName ? 56 : 8)
                .onTapGesture {
                    if !isChangingName {
                        withAnimation(.easeInOut(duration: 1)) { isChangingImage.toggle() }
                    } else {
                        withAnimation {
                            saveChanges()
                            Task { await profileViewModel.updateUser() }
                        }
                    }
                }

                ZStack {
                    if isChangingName {
                        if profileViewModel.user.username.trimmingCharacters(in: .whitespaces).count < 1 {
                            Text(hint)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .opacity(0.5)
                                .font(.custom("Montserrat-Semibold", size: 32))
                                .padding(.top, 83)
                        }
                        TextField("", text: $profileViewModel.user.username)
                            .textFieldStyle(CustomFieldStyle2(isFocused: isChangingName))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 38)
                            .padding(.top, 83)
                            .focused($isTextFieldFocused)
                            .onSubmit {
                                saveChanges()
                                Task { await profileViewModel.updateUser() }
                            }
                    } else {
                        Text(profileViewModel.user.username)
                            .padding(.bottom, 16)
                            .foregroundColor(.white)
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

                if isChangingName { Spacer() }
            }

            if isChangingImage {
                let emojiList = GetEmojis.getEmojis()
                ZStack {
                    Rectangle()
                        .frame(width: 11, height: 11)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(45))
                        .padding(.bottom, 60)
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 64)
                            .foregroundColor(.white)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                Button { isActionSheetPresented.toggle() } label: {
                                    ZStack {
                                        Circle().frame(width: 40, height: 40).foregroundColor(Color.inputBackground)
                                        Image(systemName: "camera.fill").resizable().scaledToFit().frame(width: 20, height: 18).foregroundColor(Color.primaryBlueBrand)
                                    }
                                }
                                .actionSheet(isPresented: $isActionSheetPresented) {
                                    ActionSheet(title: Text("Take a picture or choose from library"), buttons: [
                                        .cancel(),
                                        .default(Text("Take a picture")) { show.toggle() },
                                        .default(Text("Choose from library")) { show.toggle() }
                                    ])
                                }

                                ForEach(emojiList, id: \.self) { emoji in
                                    ZStack {
                                        if profileViewModel.user.userIcon != emoji.icon {
                                            Circle().frame(width: 40, height: 40).foregroundColor(Color(hex: emoji.color))
                                            Image(emoji.icon).resizable().scaledToFit()
                                                .frame(width: emoji.icon.starts(with: "memoji") ? 35 : 28, height: emoji.icon.starts(with: "memoji") ? 35 : 28)
                                        } else {
                                            Circle().stroke(Color.primaryGrey, style: StrokeStyle(lineWidth: 1))
                                                .background(Circle().foregroundColor(Color(hex: emoji.color))).frame(width: 40, height: 40)
                                            Image(emoji.icon).resizable().scaledToFit()
                                                .frame(width: emoji.icon.starts(with: "memoji") ? 35 : 28, height: emoji.icon.starts(with: "memoji") ? 35 : 28)
                                            HStack { Spacer()
                                                VStack {
                                                    ZStack {
                                                        Circle().foregroundColor(.green).frame(width: 12, height: 12)
                                                        Image("Ok").resizable().scaledToFit().foregroundColor(.white).frame(width: 7, height: 6)
                                                    }
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: 40, height: 42)
                                    .onTapGesture {
                                        withAnimation(.easeInOut) { profileViewModel.user.userIcon = emoji.icon }
                                    }
                                }
                            }
                            .padding(insets)
                        }
                    }
                }
                .offset(y: 56)
                .padding(.horizontal, 24)
                .shadow(color: Color.shadowGrey.opacity(0.2), radius: 35, x: 0, y: 8)
            }
        }
        .frame(height: isChangingName ? nil : 120)
        .edgesIgnoringSafeArea(.all)
    }
}
