//
//  ClothesCardsView.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 03.12.2022.
//

import SwiftUI
import WaterfallGrid

// MARK: - ClothesCardsView

struct ClothesCardsView: View {
    let outfit: [Cloth]
    let textError: String?
    let errorCode: Int?
    let notRealClothesTemps: [NotRealCloth]
    let color: Color?

    init(
        outfit: [Cloth],
        textError: String? = nil,
        errorCode: Int? = nil,
        notRealClothesTemps: [NotRealCloth] = [],
        color: Color? = nil
    ) {
        self.outfit = outfit
        self.textError = textError
        self.errorCode = errorCode
        self.notRealClothesTemps = notRealClothesTemps
        self.color = color
    }

    var body: some View {
        ZStack {
            if outfit.isEmpty {
                NoOutfit(textError: textError, errorCode: errorCode, accentColor: color)
                    .padding(.horizontal, 8)
            } else {
                WaterfallGrid(outfit) { item in
                    ClothesCard(cloth: item, notRealClothesTemps: notRealClothesTemps, color: color)
                        .aspectRatio(GetRatio.getRatio(type: item.type).rawValue, contentMode: .fit)
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

// MARK: - ClothesCard

struct ClothesCard: View {
    @State var cloth: Cloth
    let notRealClothesTemps: [NotRealCloth]
    let color: Color?
    @State private var isShowingSheet = false

    var body: some View {
        if cloth.id.starts(with: "Not real cloth") {
            notRealCard
        } else {
            realCard
        }
    }

    // MARK: - Not-real card

    private var notRealCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).foregroundColor(.white)
            VStack(spacing: 12) {
                clothImage.opacity(0.5)
                VStack(spacing: 4) {
                    Text(cloth.name)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .frame(width: 120)
                        .foregroundColor(Color.primaryGrey)
                    Text("Not real cloth. Tap to add yours")
                        .font(.custom("Montserrat-Regular", size: 10))
                        .multilineTextAlignment(.center)
                        .frame(width: 120)
                        .foregroundColor(Color.primaryGrey)
                }
            }
            .padding()

            temperatureBadge
        }
        .shadow(color: Color.shadowGrey.opacity(0.15), radius: 30, y: 4)
        .padding(4)
        .onTapGesture { isShowingSheet = true }
    }

    private var temperatureBadge: some View {
        VStack {
            HStack {
                Spacer()
                if let temp = notRealClothesTemps.first(where: { $0.id == cloth.id })?.temp {
                    let label = GetTemperatureRange
                        .getTemperatureRange(type: temp)
                        .components(separatedBy: " ")
                        .dropFirst().dropLast()
                        .joined(separator: " ")
                    Text(label)
                        .font(.custom("Montserrat-Regular", size: 10))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(color ?? Color.secondaryBlueBrand)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
            Spacer()
        }
        .padding(8)
    }

    // MARK: - Real card

    private var realCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).foregroundColor(.white)
            VStack(spacing: 12) {
                clothImage
                Text(cloth.name)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .multilineTextAlignment(.center)
                    .frame(width: 120)
                    .foregroundColor(Color.primaryGrey)
            }
            .padding()
        }
        .shadow(color: Color.shadowGrey.opacity(0.15), radius: 30, y: 4)
        .padding(4)
    }

    private var clothImage: some View {
        ClothImage(
            imageName: cloth.image,
            isDefault: cloth.isDefault,
            color: cloth.color,
            rawImage: nil,
            imageURL: nil,
            onAppear: {}
        )
        .scaledToFit()
        .frame(width: 100, height: 120)
    }
}

// MARK: - NoOutfit

struct NoOutfit: View {
    let textError: String?
    let errorCode: Int?
    let accentColor: Color?

    @State private var isShowingAddCloth = false
    @State private var isShowingAddOutfit = false

    init(textError: String? = nil, errorCode: Int? = nil, accentColor: Color? = nil) {
        self.textError = textError
        self.errorCode = errorCode
        self.accentColor = accentColor
    }

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 96, height: 96)
                        .foregroundColor((accentColor ?? Color.secondaryBlueBrand).opacity(0.2))
                    Image("Veshalka")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 41)
                        .foregroundColor(accentColor ?? Color.secondaryBlueBrand)
                }
                Text(textError ?? "No items in wardrobe")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color.primaryGrey)
                    .multilineTextAlignment(.center)
            }
            .frame(idealWidth: 279, idealHeight: 320)

            Spacer()

            Button {
                if errorCode == 402 { isShowingAddOutfit.toggle() }
                else { isShowingAddCloth.toggle() }
            } label: {
                ZStack {
                    Rectangle().foregroundColor(.clear)
                    Text("Add")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 24)
            .buttonStyle(DefaultColorButtonStyle(color: accentColor ?? Color.secondaryBlueBrand, radius: 24))
            .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
            .fullScreenCover(isPresented: $isShowingAddOutfit) { CreateOutfitView() }
            // .sheet(isPresented: $isShowingAddCloth) { AddClothesView(...) }
        }
    }
}
