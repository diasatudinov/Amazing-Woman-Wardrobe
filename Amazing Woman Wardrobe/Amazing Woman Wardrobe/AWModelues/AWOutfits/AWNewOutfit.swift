//
//  AWNewOutfit.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

enum ViewState {
    case create, edit
}

struct AWNewOutfit: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AWOutfitsViewModel
    @State var state: ViewState = .create
    @State var outfit: Outfit? 
    @State private var name = ""
    @State private var description = ""
    @State private var items: [Item] = []
    @State private var didLoadInitialData = false
    var body: some View {
        VStack(spacing: .zero) {
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
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(items, id: \.id) { item in
                            if let file = item.imageFileName {
                                DownsampledFileImageView(
                                    fileURL: item.imageFileName.flatMap { imageURL(for: $0) },
                                    cacheID: item.id.uuidString,
                                    contentMode: .fill
                                )
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
                                            deleteItem(item)
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
                                            deleteItem(item)
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
                    }.padding(.vertical)
                }
            }
            
            NavigationLink {
                AWAddItemView(viewModel: viewModel, items: $items)
                    .navigationBarBackButtonHidden()
            } label: {
                Text("Add item")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.vertical, 8).padding(.horizontal, 11)
                    .background(.buttons)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding(.top, 16)
            
            HStack(spacing: 20) {
                if let outfit = outfit {
                    Button {
                        deleteOutfit(outfit)
                        dismiss()
                    } label: {
                        Text("Delete")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(.deleteButton)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                    }
                    .buttonStyle(.plain)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                
                Button {
                    if state == .edit {
                        if let outfit = outfit, isValid() {
                            editOutfit(outfit)
                            dismiss()
                        }
                    } else {
                        if !name.isEmpty, !description.isEmpty {
                            let outfit = Outfit(name: name, description: description, clothes: items)
                            saveOutfit(outfit)
                            dismiss()
                        }
                    }
                } label: {
                    Text("Save")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(isValid() ? .white: .secondaryText)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(isValid() ? .buttons: .offButton)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, outfit == nil ? 80 : 0)
                    
                }
                .buttonStyle(.plain)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding(.bottom, 80)
        }
        .padding(.horizontal)
        .background(.bg)
        .hideKeyboardOnTap()
        .onAppear {
            guard !didLoadInitialData else { return }
                didLoadInitialData = true
            
            if let outfit = outfit, state == .edit {
                name = outfit.name
                description = outfit.description
                items = outfit.clothes
            }
        }
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
    
    private func deleteItem(_ item: Item) {
        if let index = items.firstIndex(where: { $0 == item }) {
            items.remove(at: index)
        }
    }
    
    private func saveOutfit(_ outfit: Outfit) {
        viewModel.add(outfit: outfit)
    }
    
    private func deleteOutfit(_ outfit: Outfit) {
        viewModel.delete(outfit: outfit)
    }
    
    private func editOutfit(_ outfit: Outfit) {
        viewModel.edit(outfit: outfit, name: name, description: description, items: items)
    }
    
    private func isValid() -> Bool {
        !name.isEmpty && !description.isEmpty
    }
}

#Preview {
    NavigationStack {
        AWNewOutfit(viewModel: AWOutfitsViewModel())
    }
}
