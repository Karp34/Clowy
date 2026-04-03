import SwiftUI

struct AddPhotoView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel

    var body: some View {
        if viewModel.image != "" || viewModel.rawImage != nil {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.separatorGrey, style: StrokeStyle(lineWidth: 1, dash: [4]))

                    VStack {
                        if viewModel.isCutting, let rawImage = viewModel.rawImage {
                            ImageLift(imageName: rawImage)
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        } else {
                            ClothImage(
                                imageName: viewModel.image,
                                isDefault: viewModel.isDefault,
                                color: viewModel.color,
                                rawImage: viewModel.rawImage,
                                imageURL: nil,
                                onAppear: {}
                            )
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        }
                    }
                    .frame(minHeight: 136)

                    HStack(alignment: .top) {
                        Spacer()
                        VStack {
                            Image(systemName: "trash")
                                .foregroundColor(Color.errorRed)
                                .frame(width: 20, height: 20)
                                .padding(16)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.imageId = viewModel.image
                            viewModel.rawImage = nil
                            viewModel.isDefault = false
                            viewModel.image = ""
                            viewModel.isCutting = false
                        }
                    }
                }

                if !viewModel.isDefault {
                    DragAndDrop { image in
                        viewModel.rawImage = image
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        } else {
            HStack(spacing: 16) {
                ImagePickerV2 { image in
                    viewModel.rawImage = image
                    viewModel.isCutting = true
                }
                UseStockPhoto()
            }
        }
    }
}
