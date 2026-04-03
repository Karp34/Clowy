//
//  DaysForecastView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 15.04.2022.
//

import SwiftUI

struct DaysForecastView: View {
    let days: [WeatherDay]
    let selectedId: Int
    let onDaySelected: (Int) -> Void

    var body: some View {
        let insets = EdgeInsets(top: 0, leading: 24, bottom: 16, trailing: 16)

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(days) { day in
                    DaysForecastCell(selected: selectedId == day.id, day: day)
                        .onTapGesture { onDaySelected(day.id) }
                }
            }
            .padding(insets)
        }
    }
}
