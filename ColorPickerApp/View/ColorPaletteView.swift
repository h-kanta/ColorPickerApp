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
                        VStack(spacing: 40) {
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
                HStack(spacing: 0) {
                    ForEach(colorPalete.colorDates, id: \.self) { color in
                        // 最初のカラーは、左下が角丸
                        if color == colorPalete.colorDates.first {
                            Rectangle()
                                .foregroundStyle(Color(hue: color.hsb.hue,
                                                       saturation: color.hsb.saturation,
                                                       brightness: color.hsb.brightness))
                                .cornerRadius(10, corners: .bottomLeft)
                        // 最後のカラーは、右下が角丸
                        } else if color == colorPalete.colorDates.last {
                            Rectangle()
                                .foregroundStyle(Color(hue: color.hsb.hue,
                                                       saturation: color.hsb.saturation,
                                                       brightness: color.hsb.brightness))
                                .cornerRadius(10, corners: .bottomRight)
                        // その他は、角丸なし
                        } else {
                            Rectangle()
                                .foregroundStyle(Color(hue: color.hsb.hue,
                                                       saturation: color.hsb.saturation,
                                                       brightness: color.hsb.brightness))
                        }
                    }
                }
            }
        }
        .frame(height: 160)
    }
}

#Preview {
    ColorPaletteView()
}
