//
//  SelectCategoryView.swift
//  Clowy
//
//  Created by Егор Карпухин on 02.11.2024.
//
import SwiftUI

struct SelectCategoryView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel
    @State var input = ""
    @FocusState private var isTextFieldFocused: Bool

    func updateCategoryNames(with input: String) -> [String] {
        let allNames = CreateDefaultWardrobe.getClothes()
            .map { $0.clothesTypeName.rawValue }
            .sorted { $0.lowercased() < $1.lowercased() }
        return input.isEmpty ? allNames : allNames.filter { $0.lowercased().hasPrefix(input.lowercased()) }
    }

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(Color.inputBackground)
                    .frame(height: 46)
                TextField("Category", text: $input)
                    .onChange(of: input) {
                        withAnimation { viewModel.categoryNames = updateCategoryNames(with: input) }
                    }
                    .onChange(of: viewModel.currentPage) {
                        isTextFieldFocused = false
                    }
                    .textFieldStyle(CustomFieldStyle3(size: 15))
                    .multilineTextAlignment(.leading)
                    .focused($isTextFieldFocused)
                    .padding(.leading, 16)
            }
            .frame(height: 46)
            .padding(.trailing, 24)

            CategorySelectorView()
        }
        .padding(.top, 4)
    }
}
