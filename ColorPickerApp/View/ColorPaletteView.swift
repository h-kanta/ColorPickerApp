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
    
    // 削除アラート
    @State var isShowDeleteAlert: Bool = false
    // 削除するパレット
    @State var paletteDeleteTarget: ColorPalette?
    
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
                            ForEach(Array(colorPalettes.enumerated()), id: \.offset) { index, colorPalette in
                                colorPaletteCardView(colorPalette: colorPalette,
                                                     colorPaletteIndex: index)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        // パレット削除アラート
        .alert("パレット削除", isPresented: $isShowDeleteAlert) {
            Button("キャンセル", role: .cancel) {
                isShowDeleteAlert = false
            }
            Button("OK", role: .destructive) {
                if let colorPalette = paletteDeleteTarget {
                    context.delete(colorPalette)
                }
            }
        } message: {
            Text("このパレットを削除します。元に戻すことはできません。よろしいですか？")
        }
    }
    
    // MARK: カラーパレットカード
    @ViewBuilder
    func colorPaletteCardView(colorPalette: ColorPalette, colorPaletteIndex: Int) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(10)
                .shadow(color: Color("Shadow2").opacity(0.20), radius: 10, x: -5, y: -3)
                .shadow(color: Color("Shadow2").opacity(0.20), radius: 10, x: 5, y: 3)
            
            VStack(spacing: 0) {
                // メニュー
                HStack {
                    // お気に入り
                    if colorPalette.isFavorite {
                        Image(systemName: Icon.favorite.symbolName() + ".fill")
                            .foregroundStyle(.red)
                            .font(.title)
                    } else {
                        Image(systemName: Icon.favorite.symbolName())
                            .foregroundStyle(.red)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    Menu {
                        // パレット編集
                        Button {
                            paletteEdit(colorPalette: colorPalette)
                        } label: {
                            Label("編集", systemImage: Icon.edit.symbolName())
                        }
                        
                        // パレット削除
                        Button(role: .destructive) {
                            paletteDelete(colorPalette: colorPalette)
                        } label: {
                            Label("削除", systemImage: Icon.trash.symbolName())
                        }
                    } label: {
                        Image(systemName: Icon.menu.symbolName())
                            .font(.title)
                            .foregroundStyle(.black)
                            .contentShape(Circle())
                    }
                }
                .padding()
                
                // パレット
                NavigationLink(destination: ColorConfirmationView(
                        colorState: ColorPickerViewState(colorDatas: colorPalette.colorDatas),
                        colorPaletteIndex: colorPaletteIndex)) {
                    GeometryReader { geometry in
                        HStack(spacing: 0) {
                            ForEach(colorPalette.colorDatas.indices, id: \.self) { index in
                                let color = colorPalette.colorDatas[index]
                                
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
        }
        .frame(height: 130)
    }
    
    // MARK: パレット編集
    private func paletteEdit(colorPalette: ColorPalette) {
        
    }
    
    // MARK: パレット削除
    private func paletteDelete(colorPalette: ColorPalette) {
        paletteDeleteTarget = colorPalette
        isShowDeleteAlert = true
    }
}

#Preview {
    ColorPaletteView()
}
