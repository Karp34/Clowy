import Foundation

final class DIContainer: ObservableObject {
    static let shared = DIContainer()

    private(set) var userId: String = ""

    // MARK: - Repositories

    private(set) var clothRepository: IClothRepository?
    private(set) var createClothRepository: ICreateClothRepository?
    private(set) var profileRepository: IProfileRepository?
    private(set) var outfitRepository: IOutfitRepository?
    private(set) var outfitViewModel: OutfitViewModel?

    // MARK: - Setup

    @MainActor func setup(userId: String) {
        self.userId = userId

        // Wardrobe
        let clothRemoteDataSource = ClothRemoteDataSource(userId: userId)
        clothRepository = ClothRepositoryImpl(remoteDataSource: clothRemoteDataSource)

        // CreateCloth
        let categoryDataSource = CategoryRemoteDataSource()
        createClothRepository = CreateClothRepositoryImpl(
            userId: userId,
            categoryDataSource: categoryDataSource
        )

        // Profile
        let profileDataSource = ProfileRemoteDataSource(userId: userId)
        profileRepository = ProfileRepositoryImpl(remoteDataSource: profileDataSource)
        
        // Outfit
        let outfitDataSource = OutfitRemoteDataSource(userId: userId)
        outfitRepository = OutfitRepositoryImpl(remoteDataSource: outfitDataSource)
        outfitViewModel = OutfitViewModel()
    }

    // MARK: - Reset

    func reset() {
        userId = ""
        clothRepository = nil
        createClothRepository = nil
        profileRepository = nil
        outfitViewModel = nil
        outfitRepository = nil
    }
}
