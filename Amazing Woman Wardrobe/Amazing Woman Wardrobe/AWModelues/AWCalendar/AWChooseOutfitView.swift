//
//  AWChooseOutfitView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWChooseOutfitView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AWOutfitsViewModel
    @Binding var bindedOutfit: Outfit?
    var columns = [
        GridItem(.adaptive(minimum: 150), spacing: 20)
    ]
    var body: some View {
        VStack {
            HStack(spacing: .zero) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: .zero) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 12)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.trailing, 4)
                        
                        
                        Text("Choose outfit")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.buttonStyle(.plain)
            }
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.outfits, id: \.id) { outfit in
                        VStack {
                            ItemsCollageView(items: outfit.clothes)
                            Text("\(outfit.name)")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundStyle(.white)
                        }.onTapGesture {
                            bindedOutfit = outfit
                            dismiss()
                        }
                    }
                    
                }.padding(.horizontal, 9)
            }
        }
        .padding(.horizontal)
        .background(.bg)
    }
}
#Preview {
    AWChooseOutfitView(viewModel: AWOutfitsViewModel(), bindedOutfit: .constant(nil))
}
