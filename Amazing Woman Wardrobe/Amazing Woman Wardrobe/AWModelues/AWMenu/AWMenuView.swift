//
//  AWMenuView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWMenuContainer: View {
    
    @AppStorage("firstOpenBB") var firstOpen: Bool = true
    var body: some View {
        NavigationStack {
            ZStack {
                if firstOpen {
                    AWOnboardingView(getStartBtnTapped: {
                        firstOpen = false
                    })
                } else {
                    AWMenuView()
                }
            }
        }
    }
}

struct AWMenuView: View {
    @State var selectedTab = 0
//    @StateObject var diveViewModel = BBMyDivesViewModel()
    private let tabs = ["My dives", "Calendar", "Stats"]
    
    var body: some View {
        ZStack {
            
            switch selectedTab {
            case 0:
                Color.black.ignoresSafeArea()
            case 1:
                Color.secondaryText.ignoresSafeArea()
            case 2:
                Color.bg.ignoresSafeArea()
            default:
                Text("default")
            }
            VStack {
                Spacer()
                
                HStack {
                    ForEach(0..<tabs.count) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            VStack(spacing: 4) {
                                Image(selectedTab == index ? selectedIcon(for: index) : icon(for: index))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 44)
                                
                                Text(text(for: index))
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(selectedTab == index ? .buttons : .calendar)
                            }
                            .frame(maxWidth: .infinity)
                            
                        }
                    }
                }.padding(.horizontal, 32)
            }
            .padding(.bottom, 30)
                .ignoresSafeArea()
            
            
        }
    }
    
    private func icon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconAW"
        case 1: return "tab2IconAW"
        case 2: return "tab3IconAW"
        default: return ""
        }
    }
    
    private func selectedIcon(for index: Int) -> String {
        switch index {
        case 0: return "tab1IconSelectedAW"
        case 1: return "tab2IconSelectedAW"
        case 2: return "tab3IconSelectedAW"
        default: return ""
        }
    }
    
    private func text(for index: Int) -> String {
        switch index {
        case 0: return "Outfits"
        case 1: return "Wardrobe"
        case 2: return "Calendar"
        default: return ""
        }
    }
}


#Preview {
    AWMenuContainer()
}
