//
//  ItemsCollageView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct ItemsCollageView: View {
    let items: [Item]
    var cornerRadius: CGFloat = 14

    private var fileNames: [String] { items.compactMap { $0.imageFileName } }
    
    var body: some View {
        GeometryReader { geo in
            let s = geo.size
            
            ZStack {
                background
                
                if fileNames.isEmpty {
                    fourPlaceholders(size: s)
                } else if fileNames.count == 1 {
                    tileFile(fileNames[0], size: s)
                } else if fileNames.count == 2 {
                    two(fileNames, size: s)
                } else if fileNames.count == 3 {
                    three(fileNames, size: s)
                } else if fileNames.count == 4 {
                    four(fileNames, size: s)
                } else {
                    moreThanFour(fileNames, size: s)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.calendar)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color(.bg))
    }

    private var placeholder: some View {
        Image(systemName: "photo.on.rectangle.angled")
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}

// MARK: - Layouts

private extension ItemsCollageView {

    func tileFile(_ fileName: String, size: CGSize) -> some View {
            FileTileView(
                url: ImageStore.shared.url(named: fileName),
                cacheKey: fileName,
                size: size,
                placeholderSystemName: "photo.circle"
            )
        }
    
    func tilePlaceholder(size: CGSize) -> some View {
            ZStack {
                Color(.secondarySystemBackground).opacity(0.2)
                Image(systemName: "photo.circle")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(size.width * 0.18)
            }
            .frame(width: size.width, height: size.height)
            .clipped()
        }

        func fourPlaceholders(size: CGSize) -> some View {
            let gap: CGFloat = 2
            let cellW = (size.width - gap) / 2
            let cellH = (size.height - gap) / 2

            return VStack(spacing: gap) {
                HStack(spacing: gap) {
                    tilePlaceholder(size: CGSize(width: cellW, height: cellH))
                    tilePlaceholder(size: CGSize(width: cellW, height: cellH))
                }
                HStack(spacing: gap) {
                    tilePlaceholder(size: CGSize(width: cellW, height: cellH))
                    tilePlaceholder(size: CGSize(width: cellW, height: cellH))
                }
            }
        }
    
    func two(_ files: [String], size: CGSize) -> some View {
            let gap: CGFloat = 2
            let w = (size.width - gap) / 2
            return HStack(spacing: gap) {
                tileFile(files[0], size: CGSize(width: w, height: size.height))
                tileFile(files[1], size: CGSize(width: w, height: size.height))
            }
        }

        func three(_ files: [String], size: CGSize) -> some View {
            let gap: CGFloat = 2
            let halfW = (size.width - gap) / 2
            let halfH = (size.height - gap) / 2

            return HStack(spacing: gap) {
                tileFile(files[0], size: CGSize(width: halfW, height: size.height))
                VStack(spacing: gap) {
                    tileFile(files[1], size: CGSize(width: halfW, height: halfH))
                    tileFile(files[2], size: CGSize(width: halfW, height: halfH))
                }
            }
        }

        func four(_ files: [String], size: CGSize) -> some View {
            let gap: CGFloat = 2
            let cellW = (size.width - gap) / 2
            let cellH = (size.height - gap) / 2

            return VStack(spacing: gap) {
                HStack(spacing: gap) {
                    tileFile(files[0], size: CGSize(width: cellW, height: cellH))
                    tileFile(files[1], size: CGSize(width: cellW, height: cellH))
                }
                HStack(spacing: gap) {
                    tileFile(files[2], size: CGSize(width: cellW, height: cellH))
                    tileFile(files[3], size: CGSize(width: cellW, height: cellH))
                }
            }
        }

        func moreThanFour(_ files: [String], size: CGSize) -> some View {
            let gap: CGFloat = 2
            let cellW = (size.width - gap) / 2
            let cellH = (size.height - gap) / 2

            let first3 = Array(files.prefix(3))
            let remaining = Array(files.dropFirst(3))
            let remainingExtra = max(0, remaining.count - 4)

            return VStack(spacing: gap) {
                HStack(spacing: gap) {
                    tileFile(first3[0], size: CGSize(width: cellW, height: cellH))
                    tileFile(first3[1], size: CGSize(width: cellW, height: cellH))
                }
                HStack(spacing: gap) {
                    tileFile(first3[2], size: CGSize(width: cellW, height: cellH))

                    ZStack {
                        MiniCollageView(fileNames: Array(remaining.prefix(4)))
                            .frame(width: cellW, height: cellH)
                            .clipped()

                        if remainingExtra > 0 {
                            ZStack {
                                Color.black.opacity(0.35)
                                Text("+\(remainingExtra)")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .frame(width: cellW, height: cellH)
                }
            }
        }
}

private struct MiniCollageView: View {
    let fileNames: [String]

    var body: some View {
        GeometryReader { geo in
            let s = geo.size
            let gap: CGFloat = 1
            let cellW = (s.width - gap) / 2
            let cellH = (s.height - gap) / 2

            ZStack {
                Color(.secondarySystemBackground).opacity(0.2)

                if fileNames.isEmpty {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                } else if fileNames.count == 1 {
                    tile(fileNames[0], size: s)
                } else if fileNames.count == 2 {
                    HStack(spacing: gap) {
                        tile(fileNames[0], size: CGSize(width: cellW, height: s.height))
                        tile(fileNames[1], size: CGSize(width: cellW, height: s.height))
                    }
                } else if fileNames.count == 3 {
                    HStack(spacing: gap) {
                        tile(fileNames[0], size: CGSize(width: cellW, height: s.height))
                        VStack(spacing: gap) {
                            tile(fileNames[1], size: CGSize(width: cellW, height: cellH))
                            tile(fileNames[2], size: CGSize(width: cellW, height: cellH))
                        }
                    }
                } else {
                    VStack(spacing: gap) {
                        HStack(spacing: gap) {
                            tile(fileNames[0], size: CGSize(width: cellW, height: cellH))
                            tile(fileNames[1], size: CGSize(width: cellW, height: cellH))
                        }
                        HStack(spacing: gap) {
                            tile(fileNames[2], size: CGSize(width: cellW, height: cellH))
                            tile(fileNames[3], size: CGSize(width: cellW, height: cellH))
                        }
                    }
                }
            }
        }
    }

    private func tile(_ fileName: String, size: CGSize) -> some View {
        FileTileView(
            url: ImageStore.shared.url(named: fileName),
            cacheKey: "mini_" + fileName,
            size: size,
            placeholderSystemName: "photo"
        )
    }
}

extension ImageStore {
    func url(named fileName: String) -> URL {
        return fileURL(named: fileName)
    }
}

private struct FileTileView: View {
    let url: URL?
    let cacheKey: String
    let size: CGSize
    let placeholderSystemName: String

    @StateObject private var loader = FileImageLoader()

    var body: some View {
        ZStack {
            if let ui = loader.image {
                Image(uiImage: ui)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: placeholderSystemName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.opacity(0.85))
                    .padding(min(size.width, size.height) * 0.18)
            }
        }
        .frame(width: size.width, height: size.height)
        .clipped()
        .onAppear {
            guard let url else { return }
            loader.load(url: url, targetSize: size, cacheKey: cacheKey)
        }
        .onDisappear { loader.cancel() }
    }
}
