//
//  AWWardrobeView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWWardrobeView: View {
    @ObservedObject var viewModel: AWOutfitsViewModel
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 20)
    ]
    @State private var openedCellID: UUID? = nil
    @State var currentItem: Item?
    @State private var showEditItem = false

    var body: some View {
        VStack {
            HStack(spacing: .zero) {
                
                Text("Wardrobe")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                NavigationLink {
                    AWNewItemView(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("+ New item")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 8).padding(.horizontal, 11)
                        .background(.buttons)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }.padding(.vertical, 8)
            
            if viewModel.outfitItems.isEmpty {
                VStack {
                    
                    Text("The wardrobe is empty.")
                    Text("Add your items — and let’s start creating outfits!")
                        .multilineTextAlignment(.center)
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxHeight: .infinity, alignment: .center)
                .padding(.bottom, 150)
                
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 18) {
                        ForEach(viewModel.outfitItems, id: \.id) { item in
                            
                            SwipeActionGridCell(
                                openedID: $openedCellID,
                                id: item.id,
                                onEdit: {
                                    currentItem = item
                                    showEditItem = true
                                },
                                onDelete: {
                                    viewModel.delete(item: item)
                                }
                            ) {
                                VStack {
                                    if let file = item.imageFileName {
                                        DownsampledFileImageView(
                                            fileURL: item.imageFileName.flatMap { imageURL(for: $0) },
                                            cacheID: "\(item.id.uuidString)_v\(item.imageVersion)",
                                            contentMode: .fill
                                        )
                                            .scaledToFit()
                                            .frame(width: 160, height: 160)
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(lineWidth: 1.5)
                                                    .foregroundStyle(.calendar)
                                            }
                                            .frame(width: 160, height: 160)
                                            
                                        
                                    } else {
                                        Image(systemName: "photo.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundStyle(.white)
                                            .padding()
                                            .clipShape(RoundedRectangle(cornerRadius: 20))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(lineWidth: 1.5)
                                                    .foregroundStyle(.calendar)
                                            }
                                    }
                                    
                                    VStack(spacing: 0) {
                                        Text("\(item.name)")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundStyle(.white)
                                        
                                        HStack(spacing: 2) {
                                            Image(item.status.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 12)
                                            
                                            Text("\(item.status.text)")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundStyle(.white)
                                        }
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal, 9)
                        .padding(.bottom, 100)
                }
            }
            
        }
        .padding(.horizontal)
        .background(.bg)
        .navigationDestination(isPresented: $showEditItem) {
            if let item = currentItem {
                AWNewItemView(viewModel: viewModel, state: .edit, item: item)
                    .navigationBarBackButtonHidden()
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        AWWardrobeView(viewModel: AWOutfitsViewModel())
    }
}
