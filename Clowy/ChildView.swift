//
//  ChildView.swift
//  Clowy
//
//  Created by Егор Карпухин on 30.06.2022.
//

import SwiftUI

struct ChildView: View {
    @ObservedObject var viewModel: ParentViewModel
    
    var body: some View {
        VStack {
            ForEach (viewModel.array, id: \.self) { number in
                SuperChildView(number: number)
                    .onTapGesture {
                        viewModel.replaceElement(in: &viewModel.array, element: number, with: number + 10)
                    }
            }
        }
    }
}
