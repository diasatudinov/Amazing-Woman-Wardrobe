//
//  AWAddItemView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWAddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AWOutfitsViewModel
    @Binding var items: [Item]
    
    @State private var currentCategory: ItemCategory = .top
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
                        
                        
                        Text("Add item")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.buttonStyle(.plain)
            }
            
            HStack(spacing: .zero) {
                ForEach(ItemCategory.allCases, id: \.self) { category in
                    Text(category.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(5)
                        .frame(width: UIScreen.main.bounds.width / 4 - 8)
                        .background(currentCategory == category ? .calendar : .clear)
                        .onTapGesture {
                            withAnimation {
                                currentCategory = category
                            }
                        }
                    
                }
            }
            .overlay {
                Rectangle()
                    .stroke(lineWidth: 1)
                    .foregroundStyle(.calendar)
            }
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.outfitItems.filter({ $0.category == currentCategory }), id: \.id) { item in
                        VStack {
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
                                    .foregroundStyle(.white)
                                    .padding()
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 1.5)
                                            .foregroundStyle(.calendar)
                                    }
                            }
                        }.onTapGesture {
                            items.append(item)
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
    AWAddItemView(viewModel: AWOutfitsViewModel(), items: .constant([
        Item(name: "White shirt", category: .top, status: .clean),
        Item(name: "Classic black trousers", category: .bottom, status: .inLaundry),
        Item(name: "Black loafers", category: .footwear, status: .clean),
        Item(name: "Gold hoop earrings", category: .accessories, status: .clean),
        Item(name: "Beige sweater", category: .top, status: .clean)
    ]))
}
