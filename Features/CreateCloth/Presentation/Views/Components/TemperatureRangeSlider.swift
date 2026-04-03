//
//  RangeSlider.swift
//  Clowy
//
//  Created by Егор Карпухин on 02.11.2024.
//

import SwiftUI

struct RangeSliderView: View {

    @Binding var selection: ClosedRange<CGFloat>
    var range: ClosedRange<CGFloat>
    var minimumDistance: CGFloat = 0
    var tint: Color = .primaryBlueBrand

    // MARK: - Private state

    @State private var slider1: GestureProperties = .init()
    @State private var slider2: GestureProperties = .init()
    @State private var indicatorWidth: CGFloat = 0
    @State private var isInitial = false

    // MARK: - Body

    var body: some View {
        GeometryReader { reader in
            let maxSliderWidth = reader.size.width - 30
            let minDist = minimumDistance == 0
                ? 0
                : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth

            VStack {
                Spacer()
                ZStack(alignment: .bottomLeading) {
                    trackBackground
                    HStack(spacing: 0) {
                        lowerThumb(maxSliderWidth: maxSliderWidth, minimumDistance: minDist)
                        upperThumb(maxSliderWidth: maxSliderWidth, minimumDistance: minDist)
                    }
                }
                .task {
                    guard !isInitial else { return }
                    isInitial = true
                    // Yield once so GeometryReader has settled before we read its size.
                    try? await Task.sleep(for: .seconds(0))
                    setInitialOffsets(maxWidth: maxSliderWidth)
                }
            }
            .frame(height: 65)
        }
        .frame(height: 65)
    }

    // MARK: - Subviews

    private var trackBackground: some View {
        Capsule()
            .fill(Color.inputBackground)
            .frame(height: 10)
            .padding(.bottom, 3)
    }

    private func lowerThumb(maxSliderWidth: CGFloat, minimumDistance: CGFloat) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(tint)
                .frame(width: 16, height: 16)
                .contentShape(.rect)
                .overlay(alignment: .bottom) {
                    valueLabel(for: selection.lowerBound)
                }
                .overlay(alignment: .leading) {
                    // Active track fill between the two thumbs
                    Rectangle()
                        .fill(tint)
                        .frame(width: indicatorWidth + 10, height: 10)
                        .offset(x: 10)
                        .allowsHitTesting(false)
                }
                .offset(x: slider1.offset)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            var translation = value.translation.width + slider1.lastStoredOffset
                            translation = min(max(translation, 0), slider2.offset - minimumDistance)
                            slider1.offset = translation
                            calculateNewRange(maxWidth: maxSliderWidth)
                        }
                        .onEnded { _ in
                            slider1.lastStoredOffset = slider1.offset
                        }
                )
        }
    }

    private func upperThumb(maxSliderWidth: CGFloat, minimumDistance: CGFloat) -> some View {
        Circle()
            .fill(tint)
            .frame(width: 16, height: 16)
            .contentShape(.rect)
            .overlay(alignment: .bottom) {
                valueLabel(for: selection.upperBound)
            }
            .offset(x: slider2.offset)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        var translation = value.translation.width + slider2.lastStoredOffset
                        translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
                        slider2.offset = translation
                        calculateNewRange(maxWidth: maxSliderWidth)
                    }
                    .onEnded { _ in
                        slider2.lastStoredOffset = slider2.offset
                    }
            )
    }

    private func valueLabel(for value: CGFloat) -> some View {
        Text(value >= 1 ? "+\(Int(value))" : "\(Int(value))")
            .font(.custom("Montserrat-Medium", size: 15))
            .foregroundColor(.white)
            .frame(minWidth: 40, minHeight: 40)
            .background(Color.primaryBlueBrand)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .offset(y: -24)
    }

    // MARK: - Logic

    /// Converts the current `selection` range into pixel offsets for both thumbs.
    /// Uses the standard `interpolated(towards:amount:)` — no custom extension needed.
    private func setInitialOffsets(maxWidth: CGFloat) {
        let startProgress = progressInRange(value: selection.lowerBound)
        let endProgress   = progressInRange(value: selection.upperBound)

        let start = CGFloat(0).interpolated(towards: maxWidth, amount: startProgress)
        let end   = CGFloat(0).interpolated(towards: maxWidth, amount: endProgress)

        slider1.offset = start
        slider1.lastStoredOffset = start

        slider2.offset = end
        slider2.lastStoredOffset = end

        calculateNewRange(maxWidth: maxWidth)
    }

    private func calculateNewRange(maxWidth: CGFloat) {
        indicatorWidth = slider2.offset - slider1.offset

        let startProgress = slider1.offset / maxWidth
        let endProgress   = slider2.offset / maxWidth

        let newStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newEnd   = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)

        selection = newStart...newEnd
    }

    /// Normalises `value` to a 0–1 progress within `range`.
    private func progressInRange(value: CGFloat) -> CGFloat {
        guard range.upperBound != range.lowerBound else { return 0 }
        return (value - range.lowerBound) / (range.upperBound - range.lowerBound)
    }

    // MARK: - Helpers

    private struct GestureProperties {
        var offset: CGFloat = 0
        var lastStoredOffset: CGFloat = 0
    }
}
