//
//  AWOutfitsView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWOutfitsView: View {
    @ObservedObject var viewModel: AWOutfitsViewModel
    var body: some View {
        VStack {
            HStack(spacing: .zero) {
                
                Text("Outfits")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                NavigationLink {
                    AWNewOutfit()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("+ New look")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 8).padding(.horizontal, 11)
                        .background(.buttons)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }.padding(.vertical, 8)
            
            if viewModel.outfits.isEmpty {
                VStack {
                    Text("It’s empty here for now 🙈")
                    Text("Add your first outfit — tap the yellow + button at the top")
                        .multilineTextAlignment(.center)
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.bottom, 150)
                
            } else {
                
            }
            
        }
        .padding(.horizontal)
        .background(.bg)
    }
    
}

#Preview {
    NavigationStack {
        AWOutfitsView(viewModel: AWOutfitsViewModel())
    }
}

