//
//  ChooseCategoryView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI
        
struct TagsView: View {
    @ObservedObject var viewModel: CreateNewClothViewModel
    
    var groupedItems: [[String]] = [[String]]()
    let sceenWidth = UIScreen.main.bounds.width
    
    
    
    init(viewModel: CreateNewClothViewModel) {
        self.viewModel = viewModel
        self.groupedItems = createGroupedItems(viewModel.categoryNames)
    }
        
    private func createGroupedItems(_ items:[String]) -> [[String]] {
        var groupedItems: [[String]] = [[String]]()
        var width: CGFloat = 0
        var tempItems: [String] = [String]()
        
        for word in viewModel.categoryNames {
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 24
            
            if (width + labelWidth + 0) < sceenWidth {
                width += labelWidth
                tempItems.append(word)
            } else {
                width = labelWidth
                groupedItems.append(tempItems)
                tempItems.removeAll()
                tempItems.append(word)
            }
        }
        
        groupedItems.append(tempItems)
        return groupedItems
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(groupedItems, id: \.self) { subItems in
                HStack(spacing: 12) {
                    ForEach(subItems, id: \.self) { word in
                        Text(word)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor( viewModel.cloth.type == ClothesType(rawValue: word) ? .white : Color.primaryGray)
                            .background( viewModel.cloth.type == ClothesType(rawValue: word) ? Color.secondaryBlueBrand : Color.secondaryGray)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .onTapGesture {
                                // if default cloth was added before - clean
                                if viewModel.cloth.type != .blank && viewModel.cloth.isDefault == true && viewModel.cloth.image != "" {
                                    viewModel.cloth.type = .blank
                                    viewModel.cloth.image = ""
                                    viewModel.cloth.isDefault = false
                                    viewModel.cloth.rawImage = nil
                                }
                                
                                viewModel.cloth.type = ClothesType(rawValue: word) ?? .blank
                                
                                // if there is no image from galary set default cloth
                                if viewModel.cloth.rawImage == nil {
                                    viewModel.cloth.image = word
                                    viewModel.cloth.isDefault = true
                                }
                            }
                    }
                    Spacer()
                }
            }
        }
    }
}
