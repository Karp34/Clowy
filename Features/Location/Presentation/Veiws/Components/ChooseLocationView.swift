//
//  ChooseLocationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import SwiftUI

struct ChooseLocationView: View {
    @StateObject private var viewModel = LocationViewModel()
    @EnvironmentObject var mainViewModel: MainScreenViewModel

    @State var location = ""
    @State var isChangingLocation = false
    @State var chosenLocation = UserDefaults.standard.string(forKey: "location")
    @State var locationHistory = UserDefaults.standard.object(forKey: "locationHistory") as? [String] ?? []
    @FocusState private var isTextFieldFocused: Bool
    let hintColor = Color(hex: "#A6B3C2")

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16).frame(width: 32, height: 4).foregroundColor(Color.primaryGrey)
                Spacer()
            }

            Text("Choose location")
                .foregroundColor(Color.primaryGrey)
                .font(.custom("Montserrat-SemiBold", size: 22))

            searchField

            if isChangingLocation {
                searchResults
            } else {
                geoButton
                historyList
            }

            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 24)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .onDisappear { refreshWeather() }
    }

    // MARK: - Search field

    private var searchField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ZStack(alignment: .leading) {
                    let textHint = viewModel.cityNames.first(where: { $0.starts(with: location) }) ?? ""
                    if isChangingLocation && textHint.starts(with: location) && location.count > 0 {
                        Text(textHint)
                            .font(.custom("Montserrat-SemiBold", size: 16))
                            .foregroundColor(hintColor)
                            .onTapGesture { location = viewModel.cityNames[0] }
                    }
                    TextField("Input location name", text: $location,
                        onEditingChanged: { if $0 { withAnimation { isChangingLocation = true } } },
                        onCommit: { commitLocation() }
                    )
                    .onChange(of: location) { Task { await viewModel.searchCities(prefixName: location) } }
                    .textFieldStyle(CustomFieldStyle())
                    .multilineTextAlignment(.leading)
                    .focused($isTextFieldFocused)
                }
                .overlay {
                    if location.count > 0 {
                        HStack {
                            Text("Input location name").font(.custom("Montserrat-Normal", size: 10)).foregroundColor(Color.primaryGrey).padding(.bottom, 34)
                            Spacer()
                        }
                    }
                }

                Spacer()
                if location.count > 0 {
                    Image(systemName: "xmark").resizable().scaledToFit().foregroundColor(Color.primaryGrey).frame(width: 14, height: 14)
                        .onTapGesture { location = "" }
                }
            }
            Rectangle().frame(height: 1).foregroundColor(isChangingLocation ? Color.primaryGrey : Color.separatorGrey)
        }
        .frame(height: 32, alignment: .bottom)
    }

    // MARK: - Search results

    @ViewBuilder
    private var searchResults: some View {
        if location.count > 1 {
            switch viewModel.stateCityName {
            case .success:
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.cityNames, id: \.self) { city in
                            Text(city).foregroundColor(Color.primaryGrey).font(.custom("Montserrat-Medium", size: 16)).padding(.leading, 16)
                                .onTapGesture { selectCity(city) }
                            RoundedRectangle(cornerRadius: 16).frame(height: 1).foregroundColor(Color.separatorGrey).opacity(0.5)
                        }
                    }
                }
                .padding(.top, 16)
            case .error:   PlaceholderErrorCities()
            case .placeholder: PlaceholderCities()
            }
        } else {
            PlaceholderCities()
        }
    }

    // MARK: - Geo button

    private var geoButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).foregroundColor(.white)
            HStack {
                Image(systemName: viewModel.useUserGeo ? "location.fill" : "location")
                    .resizable().scaledToFit().frame(width: 20, height: 20)
                    .foregroundColor(viewModel.useUserGeo ? Color.primaryBlueBrand : Color.primaryGrey)
                Text("Current geoposition").foregroundColor(Color.primaryGrey).font(.custom("Montserrat-Medium", size: 14))
                Spacer()
                if viewModel.useUserGeo {
                    ZStack {
                        Circle().foregroundColor(.green).frame(width: 18, height: 18)
                        Image("Ok").resizable().scaledToFit().foregroundColor(.white).frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 8)
        .shadow(color: Color.shadowGrey.opacity(0.1), radius: 35, x: 0, y: 8)
        .frame(height: 56)
        .onTapGesture {
            Task { await viewModel.requestCurrentLocation() }
        }
    }

    // MARK: - History list

    @ViewBuilder
    private var historyList: some View {
        if !locationHistory.isEmpty {
            VStack(spacing: 16) {
                ForEach(0..<locationHistory.count, id: \.self) { item in
                    if item != 0 { Rectangle().foregroundColor(Color.separatorGrey).opacity(0.5).frame(height: 1) }
                    HStack {
                        Text(locationHistory[item]).foregroundColor(Color.primaryGrey).font(.custom("Montserrat-Medium", size: 14))
                        Spacer()
                        if chosenLocation == locationHistory[item] && !viewModel.useUserGeo {
                            ZStack {
                                Circle().foregroundColor(.green).frame(width: 18, height: 18)
                                Image("Ok").resizable().scaledToFit().foregroundColor(.white).frame(width: 12, height: 12)
                            }
                            .padding(3)
                        }
                    }
                    .frame(height: 18).padding(.horizontal, 16)
                    .onTapGesture { selectCity(locationHistory[item]) }
                }
            }
            .padding(.vertical, 16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
        }
    }

    // MARK: - Helpers

    private func commitLocation() {
        withAnimation {
            if !viewModel.cityNames.isEmpty { location = viewModel.cityNames[0] }
            let final = location.trimmingCharacters(in: .whitespaces)
            if final.count > 0 { selectCity(final) }
            isChangingLocation = false
        }
    }

    private func selectCity(_ city: String) {
        withAnimation {
            location = ""
            viewModel.cityNames = []
            chosenLocation = city
            viewModel.setManualLocation(city)
            isChangingLocation = false
            isTextFieldFocused = false
            if !locationHistory.contains(city) {
                if locationHistory.count >= 5 { locationHistory.remove(at: locationHistory.count - 1) }
                locationHistory.insert(city, at: 0)
                UserDefaults.standard.set(locationHistory, forKey: "locationHistory")
            }
        }
    }

    private func refreshWeather() {
        Task {
            if viewModel.useUserGeo, let coord = viewModel.coordinates {
                await mainViewModel.reload(lat: coord.latitude, long: coord.longitude, locationName: nil)
            } else {
                await mainViewModel.reload(lat: nil, long: nil, locationName: chosenLocation)
            }
        }
    }
}
