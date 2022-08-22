//
//  ChooseCategoryView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct NewTagsView: View {
    @ObservedObject var viewModel: AddClothesViewModel
    
    @State var categoryNames: [String] = []
    
    @FetchRequest(
        entity: TestWardrobe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestWardrobe.id, ascending: true)]
    ) var categories: FetchedResults<TestWardrobe>
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
            Text("Category")
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color(hex: "#646C75"))
                .padding(.bottom, 8)
            TagsView(viewModel: viewModel, items: categoryNames)
        }
        .onAppear {
            if categories.count > 0 {
                for id in categories {
                    if id.name != nil {
                        categoryNames.append(id.name!)
                    }
                }
            }
            print(categoryNames)
        }
    }
}
        
struct TagsView: View {
    @ObservedObject var viewModel: AddClothesViewModel
    
    let items: [String]
    var groupedItems: [[String]] = [[String]]()
    let sceenWidth = UIScreen.main.bounds.width
    
    
    
    init(viewModel: AddClothesViewModel , items: [String]) {
        self.viewModel = viewModel
        self.items = items
        self.groupedItems = createGroupedItems(items)
    }
        
    private func createGroupedItems(_ items:[String]) -> [[String]] {
        var groupedItems: [[String]] = [[String]]()
        var width: CGFloat = 0
        var tempItems: [String] = [String]()
        
        for word in items {
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 20
            
            if (width + labelWidth + 20) < sceenWidth {
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
        VStack (alignment: .leading) {
            ForEach(groupedItems, id: \.self) { subItems in
                HStack {
                    ForEach(subItems, id: \.self) { word in
                        Text(word)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor( viewModel.clothesType == word ? .white : Color(hex: "#646C75"))
                            .background( viewModel.clothesType == word ? Color(hex: "#678CD4") : Color(hex: "#EFF0F2"))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                            .onTapGesture {
                                viewModel.clothesType = word
                            }
                    }
                }
            }
        }
    }
}

