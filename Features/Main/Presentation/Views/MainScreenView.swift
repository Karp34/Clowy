//
//  MainScreenView.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//

import SwiftUI

struct MainScreenView: View {

    // MARK: - View models (injected via environment or DI)

    @StateObject private var viewModel: MainScreenViewModel
    @StateObject private var wardrobeViewModel = WardrobeViewModel()
    @StateObject private var outfitViewModel = OutfitViewModel()
    @StateObject private var profileViewModel = ProfileViewModel()
    @StateObject private var locationViewModel = LocationViewModel()

    // MARK: - Local UI state

    @State private var tabState: Visibility = .hidden
    @State private var scrollOffset: CGPoint = .zero
    @State private var outfitPageOffset: CGFloat = 0
    @State private var showLocationSheet = false

    // MARK: - Init

    init(viewModel: MainScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    // MARK: - Computed

    private var currentOutfits: [FittingOutfit] {
        viewModel.fittingOutfitsResponse
            .first(where: { $0.id == viewModel.selectedId })?.outfits ?? []
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    scrollContent(in: geometry)
                }

                outfitPageIndicator
            }
        }
        .navigationTitle("Hello")
        .toolbar(tabState, for: .navigationBar)
        .task { await loadData() }
    }

    // MARK: - Subviews

    private func scrollContent(in geometry: GeometryProxy) -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                greetingSection
                weatherSection
                wardrobeModuleSection
                outfitsSection(in: geometry)
            }
            .readingScrollView(from: "scroll", into: $scrollOffset)
        }
        .coordinateSpace(name: "scroll")
        .gesture(horizontalSwipeGesture)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
    }

    private var greetingSection: some View {
        NavigationLink(destination: ProfileView()) {
            GreetingView(
                color: viewModel.chosenWeather.color,
                username: profileViewModel.user.username,
                avatar: profileViewModel.user.userIcon
            )
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        .padding(.top, 24)
        .buttonStyle(NoAnimationButtonStyle())
    }

    private var weatherSection: some View {
        Button { showLocationSheet.toggle() } label: {
            WeatherForecastView(
                name: viewModel.chosenWeather.name,
                color: viewModel.chosenWeather.color,
                temp: viewModel.chosenWeather.temp,
                icon: viewModel.chosenWeather.icon,
                state: viewModel.loadingState
            )
        }
        .buttonStyle(ScaleButtonStyle())
        .sheet(isPresented: $showLocationSheet) {
            ChooseLocationView()
        }
    }

    private var wardrobeModuleSection: some View {
        WardrobeModuleView(
            color: viewModel.chosenWeather.color,
            numberOfClothes: wardrobeViewModel.wardrobe.flatMap(\.items).count,
            numberOfOutfits: outfitViewModel.outfits.count
        )
        .environmentObject(wardrobeViewModel)
        .environmentObject(outfitViewModel)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
    }

    @ViewBuilder
    private func outfitsSection(in geometry: GeometryProxy) -> some View {
        switch viewModel.loadingState {
        case .success:
            Section {
                outfitCards(in: geometry)
            } header: {
                daysForecastHeader
            }
        case .error:
            HStack {
                Spacer()
                NoClothesDataPlaceholder()
                Spacer()
            }
        case .placeholder:
            ClothesLoadingPlaceholder()
        }
    }

    @ViewBuilder
    private func outfitCards(in geometry: GeometryProxy) -> some View {
        if let fittingOutfits = viewModel.fittingOutfitsResponse
            .first(where: { $0.id == viewModel.selectedId }) {
            if !fittingOutfits.outfits.isEmpty {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(fittingOutfits.outfits) { outfit in
                        VStack(spacing: 8) {
                            ClothesCardsView(
                                outfit: outfit.outfit,
                                notRealClothesTemps: viewModel.notRealClothesTemps,
                                color: viewModel.chosenWeather.color
                            )
                            .padding(.horizontal, 16)

                            AddGeneratedOutfit(isGenerated: outfit.isGenerated, outfit: outfit.outfit)

                            if fittingOutfits.outfits.count > 1 {
                                Spacer().frame(height: 56)
                            }
                        }
                        .frame(width: geometry.size.width)
                    }
                }
                .offset(x: -(outfitPageOffset * geometry.size.width))
                .animation(.default, value: outfitPageOffset)
            } else {
                NoOutfit(textError: fittingOutfits.error, errorCode: fittingOutfits.code)
                    .padding(.horizontal, 24)
            }
        }
    }

    private var daysForecastHeader: some View {
        DaysForecastView(
            days: viewModel.days,
            selectedId: viewModel.selectedId,
            onDaySelected: { id in
                withAnimation {
                    viewModel.changeWeather(id: id)
                    outfitPageOffset = 0
                }
            }
        )
        .background(
            (scrollOffset.y > 360 ? Color.primaryBackground : Color.clear)
                .frame(height: 95)
                .edgesIgnoringSafeArea(.all)
                .offset(y: -30)
        )
    }

    private var outfitPageIndicator: some View {
        VStack {
            Spacer()
            if currentOutfits.count > 1 {
                IndicatorView(selectedId: Int(outfitPageOffset), count: currentOutfits.count, backgroundColor: viewModel.chosenWeather.color)
                    .animation(.easeInOut, value: outfitPageOffset)
                    .onDisappear { outfitPageOffset = 0 }
            }
        }
    }

    private var horizontalSwipeGesture: some Gesture {
        DragGesture().onEnded { value in
            if value.translation.width > 10 {
                if outfitPageOffset > 0 { outfitPageOffset -= 1 }
            } else if value.translation.width < -10 {
                if Int(outfitPageOffset) < currentOutfits.count - 1 {
                    outfitPageOffset += 1
                }
            }
        }
    }

    // MARK: - Data loading

    private func loadData() async {
        let isGeo = locationViewModel.useUserGeo
        let lat  = isGeo ? locationViewModel.coordinates?.latitude  : nil
        let lon  = isGeo ? locationViewModel.coordinates?.longitude : nil
        let locationName = isGeo ? nil : UserDefaults.standard.string(forKey: "location")

        // Load user data and wardrobe in parallel
        async let userLoad:     () = profileViewModel.loadUser()
        async let wardrobeLoad: () = wardrobeViewModel.fetchWardrobe()
        async let outfitsLoad:  () = outfitViewModel.fetchOutfits()
        _ = await (userLoad, wardrobeLoad, outfitsLoad)

        let remoteConfig = OutfitRemoteConfigDataSource().fetch()

        await viewModel.load(
            lat: lat,
            long: lon,
            locationName: locationName,
            user: profileViewModel.user,
            clothes: wardrobeViewModel.wardrobe.flatMap(\.items),
            wardrobe: wardrobeViewModel.wardrobe,
            outfits: outfitViewModel.outfits,
            remoteConfig: remoteConfig
        )
    }
}

