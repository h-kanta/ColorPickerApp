//
//  ColorPaletteView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/17.
//

import SwiftUI
import SwiftData

struct ColorPaletteView: View {
    
    // SwiftData のデータを使用
    @Environment(\.modelContext) private var context
    // ColorPalette のデータを取得するために宣言
    @Query private var colorPalettes: [ColorPalette]
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                        VStack(spacing: 30) {
                            ForEach(colorPalettes) { colorPalette in
                                colorPaletteCardView(colorPalete: colorPalette)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
    
    // MARK: カラーパレットカード
    @ViewBuilder
    func colorPaletteCardView(colorPalete: ColorPalette) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(10)
                .shadow(color: Color("Shadow2").opacity(0.20), radius: 10, x: -5, y: -3)
                .shadow(color: Color("Shadow2").opacity(0.20), radius: 10, x: 5, y: 3)
            
            VStack(spacing: 0) {
                HStack {
                    // お気に入り
                    if colorPalete.isFavorite {
                        Image(systemName: Icon.favorite.symbolName() + ".fill")
                            .foregroundStyle(.red)
                            .font(.title)
                    } else {
                        Image(systemName: Icon.favorite.symbolName())
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    // メニュー
                    Image(systemName: Icon.menu.symbolName())
                        .font(.title)
                }
                .padding()
                
                // MARK: カラー
                GeometryReader { geometry in
                    HStack(spacing: 0) {
                        ForEach(colorPalete.colorDatas.indices, id: \.self) { index in
                            let color = colorPalete.colorDatas[index]
                            
                            if index == 0 {
                                Rectangle()
                                    .fill(Color(hue: color.hsb.hue,
                                                saturation: color.hsb.saturation,
                                                brightness: color.hsb.brightness))
                                    .frame(width: geometry.size.width * 0.3)
                                    .cornerRadius(10, corners: [.bottomLeft])
                            } else if index == 1 {
                                Rectangle()
                                    .fill(Color(hue: color.hsb.hue,
                                                saturation: color.hsb.saturation,
                                                brightness: color.hsb.brightness))
                                    .frame(width: geometry.size.width * 0.1)
                            } else {
                                Rectangle()
                                    .fill(Color(hue: color.hsb.hue,
                                                saturation: color.hsb.saturation,
                                                brightness: color.hsb.brightness))
                                    .frame(width: geometry.size.width * 0.6)
                                    .cornerRadius(10, corners: [.bottomRight])
                            }
                        }
                    }
                }
            }
        }
        .frame(height: 130)
    }
}

#Preview {
    ColorPaletteView()
}
