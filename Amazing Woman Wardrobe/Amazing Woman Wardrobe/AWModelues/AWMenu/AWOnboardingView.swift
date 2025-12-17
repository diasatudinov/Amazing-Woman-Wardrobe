//
//  AWOnboardingView.swift
//  Amazing Woman Wardrobe
//
//

import SwiftUI

struct AWOnboardingView: View {
    var getStartBtnTapped: () -> ()
    @State var count = 0
    
    var onbImage: Image {
        switch count {
        case 0:
            Image(.onboardingImg1AW)
        case 1:
            Image(.onboardingImg2AW)
        case 2:
            Image(.onboardingImg3AW)
        default:
            Image(.onboardingImg1AW)
        }
    }
    
    var onbTitle: String {
        switch count {
        case 0:
            "Your wardrobe in your\npocket"
        case 1:
            "Never stand in front of\nyour closet again"
        case 2:
            "Amazing Woman:\nWardrobe"
        default:
            ""
        }
    }
    
    var onbDescription: String {
        switch count {
        case 0:
            "Add items, create stylish outfits, and plan what to wear — no morning stress."
        case 1:
            "All your clothes and ready-made looks are always with you. Choose an outfit in seconds."
        case 2:
            "Your personal stylist in your phone: clothing catalog, outfits, and an outfit calendar."
        default:
            ""
        }
    }
    
    var body: some View {
        VStack(spacing: 32) {
            onbImage
                .resizable()
                .scaledToFit()
                .ignoresSafeArea(edges: .top)
                .overlay(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(onbTitle)
                            .font(.system(size: 32, weight: .bold))
                            .fixedSize()
                        Text(onbDescription)
                            .font(.system(size: 15, weight: .bold))
                            
                        
                    }
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 16)
                }
            
            
            VStack(spacing: 12) {
                
                HStack {
                    if count == 0 {
                        Rectangle()
                            .fill(.calendar)
                            .frame(width: 25, height: 12)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.white)
                            }
                    } else {
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.white)
                            .frame(width: 12, height: 12)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    
                    if count == 1 {
                        Rectangle()
                            .fill(.calendar)
                            .frame(width: 25, height: 12)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.white)
                            }
                    } else {
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.white)
                            .frame(width: 12, height: 12)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    if count == 2 {
                        Rectangle()
                            .fill(.calendar)
                            .frame(width: 25, height: 12)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(.white)
                            }
                    } else {
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.white)
                            .frame(width: 12, height: 12)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }                }
                
                Button {
                    if count < 2 {
                        withAnimation {
                            count += 1
                        }
                    } else {
                        getStartBtnTapped()
                    }
                } label: {
                    Text(count < 2 ? "Next" : "Get Started")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.vertical, 13)
                        .frame(width: 220)
                        .background(.buttons)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(.bg)
            .ignoresSafeArea()
    }
}

#Preview {
    AWOnboardingView(getStartBtnTapped: {})
}
