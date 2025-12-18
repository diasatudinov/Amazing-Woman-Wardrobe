//
//  AWNewOutfit.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWNewOutfit: View {
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var items: [Item] = []
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
                        
                        
                        Text("New Look")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.buttonStyle(.plain)
            }.padding(.bottom, 32)
            
            VStack {
                dataCollectCell(icon: "Name:") {
                    HStack(alignment: .bottom) {
                        TextField("", text: $name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16).padding(.vertical, 9)
                            .background(.secondaryText)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                
                dataCollectCell(icon: "Description:") {
                    HStack(alignment: .bottom) {
                        TextField("", text: $description)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16).padding(.vertical, 9)
                            .background(.secondaryText)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    }
                }
                
            }
            
            if !items.isEmpty {
                HStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        ForEach(items, id: \.self) { item in
                            if let image = item.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 164, height: 164)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(.calendar)
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            
                                        } label: {
                                            Image(systemName: "trash")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 13)
                                                .foregroundStyle(.white)
                                                .padding(4)
                                                .background(.deleteButton)
                                                .clipShape(Circle())
                                                .offset(x: 5, y: -5)
                                        }
                                    }
                            } else {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 164, height: 164)
                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(.calendar)
                                    }
                                    .overlay(alignment: .topTrailing) {
                                        Button {
                                            
                                        } label: {
                                            Image(systemName: "trash")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 13)
                                                .foregroundStyle(.white)
                                                .padding(4)
                                                .background(.deleteButton)
                                                .clipShape(Circle())
                                                .offset(x: 5, y: -5)
                                        }
                                    }
                            }
                        }
                    }
                }
            }
            
            NavigationLink {
                
            } label: {
                Text("Add item")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8).padding(.horizontal, 11)
                    .background(.buttons)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.top, 16)
            
            Button {
                dismiss()
            } label: {
                Text("Save")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 20).padding(.horizontal, 75)
                    .background(.buttons)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
            }
            .buttonStyle(.plain)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 150)
        }
        .padding(.horizontal)
        .background(.bg)
    }
    
    private func dataCollectCell<Content: View>(
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
            
            HStack(spacing: 4) {
                content()
                
            }
        }
    }
}

#Preview {
    AWNewOutfit()
}
