//
//  ColorPaletteView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/17.
//

import SwiftUI

struct ColorPaletteView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色
//                Color("BackColor")
//                    .ignoresSafeArea()
                
                VStack {
                    // MARK: ナビゲーションバー
                    CustomNavigationBarContainer(
                        // 左
                        leftContent: {
                            Spacer()
                        },
                        // 中央
                        centerContent: {
                            Text("配色一覧")
                        },
                        // 右
                        rightContent: {
                            Button {
                                
                            } label: {
                                Image(systemName: Icon.sort.symbolName())
                            }
                        }
                    )
                    
                    ScrollView {
                        VStack(spacing: 40) {
                            colorPaletteCardView()
//                            colorPaletteItemView()
//                            colorPaletteItemView()
//                            colorPaletteItemView()
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    func colorPaletteCardView() -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(10)
                .shadow(color: Color("Shadow2").opacity(0.23), radius: 8, x: -3, y: -3)
                .shadow(color: Color("Shadow2").opacity(0.23), radius: 8, x: 3, y: 3)
            
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: Icon.favorite.symbolName())
                        .foregroundStyle(.red)
                        .font(.title)
                    
                    Spacer()
                    
                    Image(systemName: Icon.menu.symbolName())
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }
                .padding()
                
                HStack(spacing: 0) {
                    Rectangle()
                        .foregroundStyle(.red)
                        .cornerRadius(10, corners: .bottomLeft)
                    Rectangle()
                        .foregroundStyle(.green)
                    Rectangle()
                        .foregroundStyle(.cyan)
                    Rectangle()
                        .foregroundStyle(.mint)
                    Rectangle()
                        .foregroundStyle(.blue)
                        .cornerRadius(10, corners: .bottomRight)
                }
            }
        }
        .frame(height: 160)
    }
}

#Preview {
    ColorPaletteView()
}
