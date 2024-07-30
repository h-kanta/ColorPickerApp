//
//  FavoriteColorView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/17.
//

import SwiftUI
import SwiftData

struct ColorStorageView: View {
    
    // ColorStorage のデータを取得するために宣言
    @Query private var colorStorages: [ColorStorage]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
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
                            Text("カラー")
                        },
                        // 右
                        rightContent: {
                            Button {
                                
                            } label: {
                                Image(systemName: Icon.sort.symbolName())
                            }
                        }
                    )
                    
                    // カラーグリッド
                    GeometryReader { geometry in
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(colorStorages, id: \.self) { color in
                                    colorGridItem(rgbColor: color.rgbColor, geometry: geometry)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 65)
        }
    }
    
    //
    func colorGridItem(rgbColor: RGBColor, geometry: GeometryProxy) -> some View {
        VStack {
            // カラー
            Rectangle()
                .frame(width: (geometry.size.width - 60) / 4,
                       height: (geometry.size.width - 60) / 4) // 60は各アイテムの間隔を考慮
                .foregroundStyle(Color(red: rgbColor.red, green: rgbColor.green, blue: rgbColor.blue))
                .cornerRadius(10, corners: .allCorners)
                .shadow(color: Color("Shadow1"), radius: 3, x: -5, y: -5)
                .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 5, y: 5)
            
            // HEXコード
            Text("#\(rgbColor.toHEX().code)")
        }
    }
}

#Preview {
    ColorStorageView()
}
