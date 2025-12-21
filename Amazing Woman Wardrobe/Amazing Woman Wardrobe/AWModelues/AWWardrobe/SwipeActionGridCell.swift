import SwiftUI

struct SwipeActionGridCell<Content: View>: View {
    let actionWidth: CGFloat = 140 // общая ширина под 2 кнопки
    let cornerRadius: CGFloat = 20

    @Binding var openedID: UUID?     // чтобы открывалась только 1 ячейка
    let id: UUID

    let onEdit: () -> Void
    let onDelete: () -> Void
    @ViewBuilder let content: () -> Content

    @State private var offsetX: CGFloat = 0
    @GestureState private var dragX: CGFloat = 0

    private var isOpen: Bool { openedID == id }

    var body: some View {
        ZStack(alignment: .trailing) {

            // Кнопки (под контентом)
            HStack(spacing: 0) {
                Spacer()

                Button {
                    close()
                    onEdit()
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "pencil")
                        Text("Edit")
                            .font(.caption.weight(.semibold))
                    }
                    .frame(width: actionWidth / 2, height: 9999)
                    .contentShape(Rectangle())
                }
                .tint(.blue)

                Button(role: .destructive) {
                    close()
                    onDelete()
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "trash")
                        Text("Delete")
                            .font(.caption.weight(.semibold))
                    }
                    .frame(width: actionWidth / 2, height: 9999)
                    .contentShape(Rectangle())
                }
                .tint(.red)
            }
            .foregroundStyle(.white)
            .background(Color.black.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))

            // Контент ячейки
            content()
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .offset(x: clampedOffset)
                .gesture(dragGesture)
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                        if isOpen { close() } else { open() }
                    }
                }
                .onChange(of: openedID) { _, _ in
                    // Если открыли другую — закрыть эту
                    if !isOpen {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            offsetX = 0
                        }
                    }
                }
        }
    }

    private var clampedOffset: CGFloat {
        // offsetX + dragX, но ограничиваем от 0 до -actionWidth
        let raw = offsetX + dragX
        return min(0, max(-actionWidth, raw))
    }

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 8, coordinateSpace: .local)
            .updating($dragX) { value, state, _ in
                // двигаем только по X
                state = value.translation.width
            }
            .onEnded { value in
                let predicted = offsetX + value.predictedEndTranslation.width
                withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                    if predicted < -actionWidth * 0.5 {
                        open()
                    } else {
                        close()
                    }
                }
            }
    }

    private func open() {
        openedID = id
        offsetX = -actionWidth
    }

    private func close() {
        if openedID == id { openedID = nil }
        offsetX = 0
    }
}