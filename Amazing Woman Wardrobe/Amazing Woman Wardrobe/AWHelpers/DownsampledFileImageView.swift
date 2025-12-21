import SwiftUI

struct DownsampledFileImageView: View {
    let fileURL: URL?
    let cacheID: String
    var contentMode: ContentMode = .fill

    @StateObject private var loader = FileImageLoader()

    var body: some View {
        GeometryReader { geo in
            ZStack {
                if let ui = loader.image {
                    Image(uiImage: ui)
                        .resizable()
                        .aspectRatio(contentMode: contentMode)
                } else {
                    Image(systemName: "photo.circle")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white.opacity(0.85))
                        .padding(18)
                }
            }
            .clipped()
            .onAppear {
                guard let url = fileURL else { return }
                let size = geo.size
                let key = "\(cacheID)_\(Int(size.width))x\(Int(size.height))"
                loader.load(url: url, targetSize: size, cacheKey: key)
            }
            .onDisappear {
                loader.cancel()
            }
        }
    }
}