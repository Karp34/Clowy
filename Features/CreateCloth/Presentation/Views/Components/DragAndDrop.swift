import SwiftUI

struct DragAndDrop: View {
    @EnvironmentObject var viewModel: CreateClothViewModel
    var onImageChange: (UIImage) -> ()

    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 16).foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.secondaryBlueBrand, style: StrokeStyle(lineWidth: 1, dash: [11]))
                VStack {
                    if let preview = viewModel.chosenImage {
                        Image(uiImage: preview)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(4)
                    } else {
                        VStack(spacing: 16) {
                            ZStack {
                                Circle()
                                    .frame(width: 46, height: 46)
                                    .foregroundColor(Color.secondaryBlueBrand)
                                    .opacity(0.1)
                                Image(systemName: "square.and.arrow.down.on.square")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(Color.secondaryBlueBrand)
                            }
                            Text("Drag & Drop")
                                .font(.custom("Montserrat-SemiBold", size: 12))
                                .foregroundColor(Color.primaryGrey)
                        }
                    }
                }
            }
            .background(Color.primaryBackground)
            .dropDestination(for: Data.self) { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    viewModel.chosenImage = droppedImage
                    onImageChange(droppedImage)
                    return true
                }
                return false
            } isTargeted: { _ in }
        }
    }
}
