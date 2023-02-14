//
//  CleanTagsView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct CleanTagsView: View {
    
    let items: [String]
    var groupedItems: [[String]] = [[String]]()
    let sceenWidth = UIScreen.main.bounds.width
    
    
    
    init(items: [String]) {
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
                            .padding(.horizontal, 8)
                            .padding(.vertical, 6)
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#646C75"))
                            .background( Color(hex: "#EFF0F2"))
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
            }
        }
    }
}

