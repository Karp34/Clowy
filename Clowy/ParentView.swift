//
//  ParentView.swift
//  Clowy
//
//  Created by Егор Карпухин on 30.06.2022.
//

import SwiftUI

class ParentViewModel: ObservableObject {
    @Published var array: [Int] = [1, 2, 3]
    
    static var shared = ParentViewModel()
    
    func replaceElement(in array: inout [Int], element old: Int, with new: Int) -> [Int] {
        if let i = array.firstIndex(of: old) {
            array[i] = new
        }
        return array
    }
}

struct ParentView: View {
    @StateObject private var viewModel = ParentViewModel.shared
    
    var body: some View {
        ChildView(viewModel: viewModel)
    }
}

struct ParentView_Previews: PreviewProvider {
    static var previews: some View {
        ParentView()
    }
}
