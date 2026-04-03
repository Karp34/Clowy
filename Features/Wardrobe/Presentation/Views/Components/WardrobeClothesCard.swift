//
//  WardrobeClothesCard.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI
import FirebaseStorage

struct WardrobeClothesCard: View {
    @State var cloth: Cloth
    var notRealClothesTemps: [NotRealCloth]?
    var color: Color?

    @State private var isShowingSheet = false
    @State private var imageURL: URL? = nil

    var body: some View {
        if cloth.id.starts(with: "Not real cloth") {
            notRealClothCard
        } else {
            realClothCard
        }
    }

    // MARK: - Real cloth

    private var realClothCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack(spacing: 12) {
                ClothImage(
                    imageName: cloth.image,
                    isDefault: cloth.isDefault,
                    color: cloth.color,
                    rawImage: nil,
                    imageURL: imageURL,
                    onAppear: { await loadImageURL() }
                )
                .scaledToFit()
                .frame(width: 100, height: 120)

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

    // MARK: - Not real cloth

    private var notRealClothCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack(spacing: 12) {
                ClothImage(
                    imageName: cloth.image,
                    isDefault: cloth.isDefault,
                    color: cloth.color,
                    rawImage: nil,
                    imageURL: imageURL,
                    onAppear: { await loadImageURL() }
                )
                .scaledToFit()
                .frame(width: 100, height: 120)
                .opacity(0.5)

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

            if let notRealClothesTemps, !notRealClothesTemps.isEmpty {
                temperatureBadge(notRealClothesTemps: notRealClothesTemps)
            }
        }
        .shadow(color: Color.shadowGrey.opacity(0.15), radius: 30, y: 4)
        .padding(4)
        .onTapGesture {
            isShowingSheet = true
        }
        .sheet(isPresented: $isShowingSheet) {
            CreateNewClothView(isEditingCloth: true, cloth: cloth, isShowingSheet: $isShowingSheet)
        }
    }

    // MARK: - Temperature badge

    private func temperatureBadge(notRealClothesTemps: [NotRealCloth]) -> some View {
        VStack {
            HStack {
                Spacer()
                if let temp = notRealClothesTemps.first(where: { $0.id == cloth.id })?.temp {
                    let tempName = GetTemperatureRange
                        .getTemperatureRange(type: temp)
                        .components(separatedBy: " ")
                        .dropLast()
                        .dropFirst()
                        .joined(separator: " ")
                    Text(tempName)
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

    // MARK: - Image loading

    private func loadImageURL() async {
        guard !cloth.isDefault, imageURL == nil else { return }
        let ref = Storage.storage().reference().child(cloth.image)
        imageURL = try? await ref.downloadURL()
    }
}
