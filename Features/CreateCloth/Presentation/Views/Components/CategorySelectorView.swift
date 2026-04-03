import SwiftUI

struct CategorySelectorView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel

    var groupedItems: [[String]] = []
    let screenWidth = UIScreen.main.bounds.width

    init() {}

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(createGroupedItems(viewModel.categoryNames), id: \.self) { subItems in
                HStack(spacing: 12) {
                    ForEach(subItems, id: \.self) { word in
                        Text(word)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(viewModel.type == ClothesType(rawValue: word) ? .white : Color.primaryGrey)
                            .background(viewModel.type == ClothesType(rawValue: word) ? Color.secondaryBlueBrand : Color.secondaryGrey)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .onTapGesture {
                                if viewModel.type != .blank && viewModel.isDefault && viewModel.image != "" {
                                    viewModel.type = .blank
                                    viewModel.image = ""
                                    viewModel.isDefault = false
                                    viewModel.rawImage = nil
                                }
                                viewModel.type = ClothesType(rawValue: word) ?? .blank
                                if viewModel.rawImage == nil {
                                    viewModel.image = word
                                    viewModel.isDefault = true
                                }
                            }
                    }
                    Spacer()
                }
            }
        }
    }

    private func createGroupedItems(_ items: [String]) -> [[String]] {
        var grouped: [[String]] = []
        var width: CGFloat = 0
        var temp: [String] = []

        for word in items {
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            let labelWidth = label.frame.size.width + 24

            if (width + labelWidth) < screenWidth {
                width += labelWidth
                temp.append(word)
            } else {
                width = labelWidth
                grouped.append(temp)
                temp = [word]
            }
        }
        grouped.append(temp)
        return grouped
    }
}
