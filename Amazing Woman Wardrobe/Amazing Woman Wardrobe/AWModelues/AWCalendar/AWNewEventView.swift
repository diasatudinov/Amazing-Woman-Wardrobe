//
//  AWNewEventView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWNewEventView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: AWOutfitsViewModel
    @State private var name = ""
    @State private var date: Date = Date.now
    @State private var currentType: EventType = .other
    @State private var outfit: Outfit?

    var columns = [
        GridItem(.adaptive(minimum: 130), spacing: 0)
    ]
    
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
                
                dataCollectCell(icon: "Date") {
                    HStack(alignment: .center) {
                        DatePicker(
                            "",
                            selection: $date,
                            displayedComponents: .date
                        ).labelsHidden()
                            .tint(.buttons)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .font(.system(size: 25, weight: .semibold))
                            .foregroundStyle(.calendar)
                    }
                    .padding(.vertical, 5).padding(.horizontal, 16)
                    .background(.secondaryText)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                }
                
                dataCollectCell(icon: "Type:") {
                    VStack(alignment: .leading) {
                        LazyVGrid(columns: columns, alignment: .leading) {
                            ForEach(EventType.allCases, id: \.self) { type in
                                    Text(type.rawValue)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(.white)
                                        .padding(.vertical, 6).padding(.horizontal, 20)
                                        .background(currentType == type ? .calendar : .clear)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .overlay(content: {
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(lineWidth: 1)
                                                .foregroundStyle(.calendar)
                                        })
                                        .onTapGesture {
                                            withAnimation {
                                                currentType = type
                                            }
                                        }
                                
                            }
                            Spacer()
                        }
                        
                    }.frame(maxWidth: .infinity)
                }
                
                if let outfit {
                    VStack {
                        ItemsCollageView(items: outfit.clothes)
                            .frame(height: 160)
                        Text("\(outfit.name)")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .frame(maxHeight: .infinity, alignment: .center)
                } else {
                    NavigationLink {
                        AWChooseOutfitView(viewModel: viewModel, bindedOutfit: $outfit)
                    } label: {
                        Text("Choose outfit")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(.vertical, 8).padding(.horizontal, 8)
                            .background(.buttons)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .frame(maxHeight: .infinity, alignment: .center)
                    }
                    
                }
            }
                                    
            HStack(spacing: 20) {
                
                Button {
                    if isValid() {
                        var event = Event(name: name, date: date, type: currentType)
                        
                        if let outfit {
                            event.outfit = outfit
                        }
                        saveEvent(event)
                        
                        dismiss()
                    }
                    
                } label: {
                    Text("Save")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(isValid() ? .white: .secondaryText)
                        .padding(.vertical, 20)
                        .frame(maxWidth: .infinity)
                        .background(isValid() ? .buttons: .offButton)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 80)
                    
                }
                .buttonStyle(.plain)
            }
            .padding(.bottom, 80)
        }
        .padding(.horizontal)
        .background(.bg)
        .hideKeyboardOnTap()
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
    
    private func saveEvent(_ event: Event) {
        viewModel.add(event: event)
    }
        
    private func isValid() -> Bool {
        outfit != nil && !name.isEmpty
    }
}

#Preview {
    NavigationStack {
        AWNewEventView(viewModel: AWOutfitsViewModel())
    }
}
