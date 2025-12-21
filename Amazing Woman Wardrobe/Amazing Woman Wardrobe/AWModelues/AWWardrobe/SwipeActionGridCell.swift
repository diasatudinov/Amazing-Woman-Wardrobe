//
//  SwipeActionGridCell.swift
//  Amazing Woman Wardrobe
//
//


import SwiftUI

struct SwipeActionGridCell<Content: View>: View {
    let actionWidth: CGFloat = 50
    let cornerRadius: CGFloat = 20

    @Binding var openedID: UUID?
    let id: UUID

    let onEdit: () -> Void
    let onDelete: () -> Void
    @ViewBuilder let content: () -> Content

    @State private var offsetX: CGFloat = 0

    private var isOpen: Bool { openedID == id }

    var body: some View {
        ZStack(alignment: .trailing) {

            if openedID == id {

                VStack(spacing: 10) {
                    Button {
                        close()
                        onEdit()
                        print("onEdit")
                    } label: {
                        Image(.editBtnAW)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                    
                    Button(role: .destructive) {
                        close()
                        onDelete()
                        print("onDelete")
                    } label: {
                        Image(.deleteBtnAW)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 40)
                    }
                }
            }

            content()
                .offset(x: offsetX)
                .onChange(of: openedID) { _ in
                    if !isOpen {
                        withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                            offsetX = 0
                        }
                    }
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.9)) {
                        if isOpen { close() } else { open() }
                    }
                }
        }
    }

    private var clampedOffset: CGFloat {
        let raw = offsetX
        return min(0, max(-actionWidth, raw))
    }

    private func open() {
        openedID = id
        withAnimation {
            offsetX = -actionWidth
        }
    }

    private func close() {
        if openedID == id { openedID = nil }
        withAnimation {
            offsetX = 0
        }
    }
}

#Preview {
    NavigationStack {
        AWWardrobeView(viewModel: AWOutfitsViewModel())
    }
}
