struct ItemsCollageView: View {
    let items: [Item]
    var cornerRadius: CGFloat = 14

    private var images: [UIImage] { items.compactMap { $0.image } }

    var body: some View {
        GeometryReader { geo in
            let s = geo.size
            ZStack {
                background

                if images.isEmpty {
                    placeholder
                } else if images.count == 1 {
                    tile(images[0], size: s)
                } else if images.count == 2 {
                    two(images, size: s)
                } else if images.count == 3 {
                    three(images, size: s)
                } else if images.count == 4 {
                    four(images, size: s)
                } else {
                    moreThanFour(images, size: s)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
        .aspectRatio(1, contentMode: .fit) // квадратная ячейка; убери если не нужно
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(Color(.secondarySystemBackground))
    }

    private var placeholder: some View {
        Image(systemName: "photo.on.rectangle.angled")
            .font(.system(size: 22, weight: .semibold))
            .foregroundStyle(.secondary)
    }
}

// MARK: - Layouts

private extension ItemsCollageView {

    func tile(_ uiImage: UIImage, size: CGSize) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .clipped()
    }

    func two(_ imgs: [UIImage], size: CGSize) -> some View {
        let gap: CGFloat = 2
        let w = (size.width - gap) / 2
        return HStack(spacing: gap) {
            tile(imgs[0], size: CGSize(width: w, height: size.height))
            tile(imgs[1], size: CGSize(width: w, height: size.height))
        }
    }

    func three(_ imgs: [UIImage], size: CGSize) -> some View {
        // 2×2 сетка, где первая картинка занимает всю левую половину
        let gap: CGFloat = 2
        let halfW = (size.width - gap) / 2
        let halfH = (size.height - gap) / 2

        return HStack(spacing: gap) {
            tile(imgs[0], size: CGSize(width: halfW, height: size.height))
            VStack(spacing: gap) {
                tile(imgs[1], size: CGSize(width: halfW, height: halfH))
                tile(imgs[2], size: CGSize(width: halfW, height: halfH))
            }
        }
    }

    func four(_ imgs: [UIImage], size: CGSize) -> some View {
        let gap: CGFloat = 2
        let cellW = (size.width - gap) / 2
        let cellH = (size.height - gap) / 2

        return VStack(spacing: gap) {
            HStack(spacing: gap) {
                tile(imgs[0], size: CGSize(width: cellW, height: cellH))
                tile(imgs[1], size: CGSize(width: cellW, height: cellH))
            }
            HStack(spacing: gap) {
                tile(imgs[2], size: CGSize(width: cellW, height: cellH))
                tile(imgs[3], size: CGSize(width: cellW, height: cellH))
            }
        }
    }

    func moreThanFour(_ imgs: [UIImage], size: CGSize) -> some View {
        let gap: CGFloat = 2
        let cellW = (size.width - gap) / 2
        let cellH = (size.height - gap) / 2

        let first3 = Array(imgs.prefix(3))
        let remaining = Array(imgs.dropFirst(3))
        let remainingExtra = max(0, remaining.count - 4) // сколько не поместилось в мини-коллаж

        return VStack(spacing: gap) {
            HStack(spacing: gap) {
                tile(first3[0], size: CGSize(width: cellW, height: cellH))
                tile(first3[1], size: CGSize(width: cellW, height: cellH))
            }
            HStack(spacing: gap) {
                tile(first3[2], size: CGSize(width: cellW, height: cellH))

                // 4-я плитка = мини-коллаж оставшихся
                ZStack {
                    MiniCollageView(images: Array(remaining.prefix(4)))
                        .frame(width: cellW, height: cellH)
                        .clipped()

                    if remainingExtra > 0 {
                        // бейдж +N поверх 4-й плитки
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

// MARK: - Mini collage (внутри 4-й плитки)

private struct MiniCollageView: View {
    let images: [UIImage]

    var body: some View {
        GeometryReader { geo in
            let s = geo.size
            let gap: CGFloat = 1
            let cellW = (s.width - gap) / 2
            let cellH = (s.height - gap) / 2

            ZStack {
                Color(.secondarySystemBackground)

                if images.isEmpty {
                    Image(systemName: "photo")
                        .foregroundStyle(.secondary)
                } else if images.count == 1 {
                    img(images[0]).frame(width: s.width, height: s.height)
                } else if images.count == 2 {
                    HStack(spacing: gap) {
                        img(images[0]).frame(width: cellW, height: s.height)
                        img(images[1]).frame(width: cellW, height: s.height)
                    }
                } else if images.count == 3 {
                    HStack(spacing: gap) {
                        img(images[0]).frame(width: cellW, height: s.height)
                        VStack(spacing: gap) {
                            img(images[1]).frame(width: cellW, height: cellH)
                            img(images[2]).frame(width: cellW, height: cellH)
                        }
                    }
                } else {
                    VStack(spacing: gap) {
                        HStack(spacing: gap) {
                            img(images[0]).frame(width: cellW, height: cellH)
                            img(images[1]).frame(width: cellW, height: cellH)
                        }
                        HStack(spacing: gap) {
                            img(images[2]).frame(width: cellW, height: cellH)
                            img(images[3]).frame(width: cellW, height: cellH)
                        }
                    }
                }
            }
        }
    }

    private func img(_ uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .clipped()
    }
}