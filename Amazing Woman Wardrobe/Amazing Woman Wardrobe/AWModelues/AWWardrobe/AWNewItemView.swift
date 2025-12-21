//
//  AWNewItemView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWNewItemView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AWOutfitsViewModel
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State var state: ViewState = .create
    @State var item: Item?
    @State private var name = ""
    @State private var currentCategory: ItemCategory = .top
    @State private var currentStatus: ItemStatus = .clean
    
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
                        
                        
                        Text("New item")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }.buttonStyle(.plain)
            }.padding(.bottom, 32)
            
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 160, height: 160)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 1.5)
                                .foregroundStyle(.calendar)
                        }
                        .overlay(alignment: .topTrailing) {
                            Button {
                                self.selectedImage = nil
                            } label: {
                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                    .foregroundStyle(.white)
                                    .padding(5)
                                    .background(.deleteButton)
                                    .clipShape(Circle())
                                    .offset(x: 8, y: -8)
                            }
                        }
                } else {
                    Image(systemName: "camera.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.buttons)
                        .padding(.vertical, 35).padding(.horizontal, 25)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(lineWidth: 1.5)
                                .foregroundStyle(.calendar)
                        }
                        .frame(height: 160)
                        .onTapGesture {
                            showingImagePicker = true
                        }
                }
                
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
                
                dataCollectCell(icon: "Category:") {
                    VStack(alignment: .leading) {
                        HStack(spacing: 8) {
                            ForEach(ItemCategory.allCases, id: \.self) { category in
                                if category != .accessories {
                                    Text(category.rawValue)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 6).padding(.horizontal, 20)
                                        .background(currentCategory == category ? .calendar : .clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(lineWidth: 1)
                                                .foregroundStyle(.calendar)
                                        })
                                        .onTapGesture {
                                            withAnimation {
                                                currentCategory = category
                                            }
                                        }
                                }
                            }
                            Spacer()
                        }
                        
                        HStack(spacing: 8) {
                            ForEach(ItemCategory.allCases, id: \.self) { category in
                                if category == .accessories {
                                    Text(category.rawValue)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 10).padding(.horizontal, 20)
                                        .background(currentCategory == category ? .calendar : .clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(lineWidth: 1)
                                                .foregroundStyle(.calendar)
                                        })
                                        .onTapGesture {
                                            withAnimation {
                                                currentCategory = category
                                            }
                                        }
                                }
                            }
                            Spacer()
                        }
                    }.frame(maxWidth: .infinity)
                }
                
                dataCollectCell(icon: "Status:") {
                    VStack(alignment: .leading) {
                        HStack(spacing: 8) {
                            ForEach(ItemStatus.allCases, id: \.self) { status in
                                HStack(spacing: 2) {
                                    Image(status.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 12)
                                    
                                    Text("\(status.text)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.white)
                                        
                                }
                                .padding(.vertical, 10).padding(.horizontal, 20)
                                .background(currentStatus == status ? .buttons : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(lineWidth: 1)
                                        .foregroundStyle(.buttons)
                                })
                                .onTapGesture {
                                    withAnimation {
                                        currentStatus = status
                                    }
                                }
                                
                            }
                            Spacer()
                        }
                    }.frame(maxWidth: .infinity)
                }
                
            }
                                    
            HStack(spacing: 20) {
                if let item = item {
                    Button {
                        deleteItem(item)
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
                        if let item = item, !name.isEmpty {
                            editItem(item)
                            dismiss()
                        }
                    } else {
                        if !name.isEmpty {
                            
                            var item = Item(name: name, category: currentCategory, status: currentStatus)
                            
                            if let selectedImage {
                                do {
                                    item.imageFileName = try ImageStore.shared.save(image: selectedImage, id: item.id)
                                } catch {
                                    print("Save image error:", error)
                                }
                            }
                            
                            saveItem(item)
                            
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
                        .padding(.horizontal, item == nil ? 80 : 0)
                    
                }
                .buttonStyle(.plain)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
            .padding(.bottom, 150)
        }
        .padding(.horizontal)
        .background(.bg)
        .hideKeyboardOnTap()
        .onAppear {
            if let item = item, state == .edit {
                if let file = item.imageFileName,
                   let uiImage = ImageStore.shared.load(named: file) {
                    selectedImage = uiImage
                }
                name = item.name
                currentCategory = item.category
                currentStatus = item.status
            }
        }
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(selectedImage: $selectedImage, isPresented: $showingImagePicker)
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
    
    private func saveItem(_ item: Item) {
        viewModel.add(item: item)
    }
    
    private func deleteItem(_ item: Item) {
        viewModel.delete(item: item)
    }
    
    private func editItem(_ item: Item) {
        
        if let selectedImage {
            do {
                let newFileName = try ImageStore.shared.save(image: selectedImage, id: UUID())
                viewModel.increaseVersion(item: item, image: newFileName)
            } catch {
                print("Save image error:", error)
            }
        }
        
        viewModel.edit(item: item, image: nil, name: name, category: currentCategory, status: currentStatus)
    }
    
    private func isValid() -> Bool {
        !name.isEmpty
    }
    
    private func loadImage() {
        if let selectedImage = selectedImage {
            print("Selected image size: \(selectedImage.size)")
        }
    }
}

#Preview {
    AWNewItemView(viewModel: AWOutfitsViewModel())
}
