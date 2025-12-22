//
//  AWOutfitsView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWOutfitsView: View {
    @ObservedObject var viewModel: AWOutfitsViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 20)
    ]
    
    @State var currentOutfit: Outfit?
    @State private var showEditOutfit = false
    @State private var showOutfitDetails = false
    var body: some View {
        VStack {
            HStack(spacing: .zero) {
                
                Text("Outfits")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                NavigationLink {
                    AWNewOutfit(viewModel: viewModel)
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
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(viewModel.outfits, id: \.id) { outfit in
                            VStack {
                                ItemsCollageView(items: outfit.clothes)
                                Text("\(outfit.name)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(.white)
                            }.onTapGesture {
                                currentOutfit = outfit
                                showOutfitDetails = true
                            }
                        }
                    }.padding(.horizontal, 9)
                        .padding(.bottom, 100)
                }
            }
            
        }
        .padding(.horizontal)
        .background(.bg)
        .overlay {
            if let outfit = currentOutfit, showOutfitDetails {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                        .onTapGesture {
                            currentOutfit = nil
                        }
                    
                    VStack(alignment: .leading) {
                        Text(outfit.name)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundStyle(.white)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(outfit.clothes, id: \.id) { item in
                                    if let file = item.imageFileName {
                                        DownsampledFileImageView(
                                            fileURL: item.imageFileName.flatMap { imageURL(for: $0) },
                                            cacheID: item.id.uuidString,
                                            contentMode: .fill
                                        )
                                            .scaledToFill()
                                            .frame(width: 160, height: 160)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(lineWidth: 1.5)
                                                    .foregroundStyle(.calendar)
                                            }
                                        
                                    } else {
                                        Image(systemName: "photo.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 150)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(lineWidth: 1.5)
                                                    .foregroundStyle(.calendar)
                                            }
                                    }
                                }
                            }
                        }
                        
                        Text(outfit.description)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxHeight: .infinity, alignment: .top)
                        
                        Button {
                            DispatchQueue.main.async {
                                currentOutfit = outfit
                                showEditOutfit = true
                            }
                            
                            showOutfitDetails = false
                            
                        } label: {
                            Text("Edit")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundStyle(.white)
                                .padding(.vertical, 20).padding(.horizontal, 80)
                                .background(.buttons)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }.buttonStyle(.plain)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: UIScreen.main.bounds.height / 2)
                    .padding(.horizontal).padding(.vertical, 20)
                    .background(.bg)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(lineWidth: 1.5)
                            .foregroundStyle(.calendar)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationDestination(isPresented: $showEditOutfit) {
            if let outfit = currentOutfit {
                AWNewOutfit(viewModel: viewModel, state: .edit, outfit: outfit)
                    .navigationBarBackButtonHidden()
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        AWOutfitsView(viewModel: AWOutfitsViewModel())
    }
}

