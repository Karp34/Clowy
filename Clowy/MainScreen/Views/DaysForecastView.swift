//
//  DaysForecastView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 15.04.2022.
//

import SwiftUI

protocol DaysForecastViewDelegate {
    func dayIsChanged(id: Int)
}

struct DaysForecastView: View {
    @ObservedObject private var viewModel = MainScreenViewModel()
    
    var delegate: DaysForecastViewDelegate
    var days: [Day]
    var selectedId: Int
    
    var body: some View {
        let insets = EdgeInsets(top: 0, leading: 24, bottom: 16, trailing: 16)

        ScrollView (.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                 if !days.isEmpty {
                     ForEach(0..<days.count, id: \.self) { index in
                         let day = days[index]
                         let selected = selectedId == day.id
                         DaysForecastCell(selected: selected, day: day)
                             .onTapGesture {
                                 withAnimation () {
                                     delegate.dayIsChanged(id: day.id)
                                 }
                              }
                     }
                 }
             }
            .padding(insets)
        }
    }
}
    
