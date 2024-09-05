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
    @Query(sort: \ColorPalette.createdAt, order: .reverse) private var colorPalettes: [ColorPalette]
    
    // 削除アラート
    @State var isShowDeleteAlert: Bool = false
    // 削除するパレット
    @State var paletteDeleteTarget: ColorPalette?
    // テーマ名編集アラート
    @State var isShowPaletteNameEditAlert: Bool = false
    // テーマ名を編集するパレット
    @State var paletteNameEditTarget: ColorPalette?
    // テーマ名入力テキスト
    @State var paletteThemeNameText: String = ""
    
    // カラーピッカービュー遷移
    @State var isShowColorPickerView: Bool = false
    
    // 選択タブ
    @State var currentTab: ColorPaletteTab = .all
    // タブエフェクト
    @Namespace private var animation
    
    // 触覚フィードバック
    @State var success: Bool = false
    
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
                            Text("配色")
                        },
                        // 右
                        rightContent: {
                            Spacer()
                        }
                    )
                    
                    // MARK: タブ
                    ColorPaletteTabView()
                    
                    // タブに応じて切り替える
                    switch currentTab {
                    case .all: // HSB
                        ScrollView {
                            VStack(spacing: 30) {
                                ForEach(Array(colorPalettes.enumerated()), id: \.offset) { index, colorPalette in
                                    colorPaletteCardView(colorPalette: colorPalette,
                                                         colorPaletteId: colorPalette.id,
                                                         colorState: ColorPickerViewState(colorDatas: colorPalette.colorDatas),
                                                         paletteThemeName: colorPalette.themeName)
                                }
                            }
                            .padding()
                        }
                    case .favorite: // RGB
                        ScrollView {
                            VStack(spacing: 30) {
                                ForEach(Array(colorPalettes.enumerated()), id: \.offset) { index, colorPalette in
                                    if colorPalette.isFavorite {
                                        colorPaletteCardView(colorPalette: colorPalette,
                                                             colorPaletteId: colorPalette.id,
                                                             colorState: ColorPickerViewState(colorDatas: colorPalette.colorDatas),
                                                             paletteThemeName: colorPalette.themeName)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        // パレット削除アラート
        .alert("本当に削除しますか？", isPresented: $isShowDeleteAlert) {
            Button("キャンセル", role: .cancel) {
                isShowDeleteAlert = false
            }
            Button("削除", role: .destructive) {
                if let colorPalette = paletteDeleteTarget {
                    context.delete(colorPalette)
                    success.toggle()
                }
            }
        } message: {
            Text("削除したパレットを後から復元することはできません。")
        }
        // パレットテーマ名編集アラート
        .alert("テーマ名を入力してください。", isPresented: $isShowPaletteNameEditAlert) {
            TextField("テーマ名", text: $paletteThemeNameText)
                .onChange(of: paletteThemeNameText) {
                    // 最大桁数6桁を超えた場合、テキストを切り詰める
                    if paletteThemeNameText.count > 15 {
                        paletteThemeNameText = String(paletteThemeNameText.prefix(15))
                    }
                }
            
            Button("キャンセル") {
                isShowPaletteNameEditAlert = false
            }
            Button("OK") {
                // 編集
                if let palette = paletteNameEditTarget {
                    palette.themeName = paletteThemeNameText
                    palette.updatedAt = Date()
                    try? context.save()
                }
                
                isShowPaletteNameEditAlert = false
                success.toggle()
            }
        }
        .sensoryFeedback(.success, trigger: success)
    }
    
    // MARK: カラーパレットカード
    @ViewBuilder
    func colorPaletteCardView(colorPalette: ColorPalette, 
                              colorPaletteId: String,
                              colorState: ColorPickerViewState,
                              paletteThemeName: String) -> some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.white)
                .cornerRadius(10)
                .shadow(color: Color("Shadow2").opacity(0.2), radius: 10, x: 5, y: 5)
            
            VStack(spacing: 0) {
                // メニュー
                HStack {
                    // テーマ名
                    Text(colorPalette.themeName)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    // お気に入り
                    if colorPalette.isFavorite {
                        Image(systemName: Icon.favorite.symbolName() + ".fill")
                            .foregroundStyle(.red)
                            .font(.title)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    paletteFavoriteUpdate(colorPalette: colorPalette)
                                }
                            }
                    } else {
                        Image(systemName: Icon.favorite.symbolName())
                            .foregroundStyle(.red)
                            .font(.title)
                            .onTapGesture {
                                withAnimation(.spring) {
                                    paletteFavoriteUpdate(colorPalette: colorPalette)
                                }
                            }
                    }
                    
                    // パレット削除
//                    Button {
//                        paletteDelete(colorPalette: colorPalette)
//                    } label: {
//                        Image(systemName: Icon.trash.symbolName())
//                            .foregroundStyle(.red)
//                            .font(.title2)
//                    }
                    
//                    Menu {
//                        // パレット編集
//                        Button {
//                            paletteEdit(colorState: colorState, index: colorPaletteIndex)
//                        } label: {
//                            Label("編集", systemImage: Icon.edit.symbolName())
//                        }
//                        
//                        // パレット削除
//                        Button(role: .destructive) {
//                            paletteDelete(colorPalette: colorPalette)
//                        } label: {
//                            Label("削除", systemImage: Icon.trash.symbolName())
//                        }
//                    } label: {
//                        Image(systemName: Icon.menu.symbolName())
//                            .font(.title)
//                            .foregroundStyle(.black)
//                    }
//                    .contentShape(Circle())
                }
                .padding()
                
                // パレット
                NavigationLink(destination: ColorPaletteConfirmationView(
                        colorState: colorState,
                        colorPaletteId: colorPaletteId,
                        paletteThemeName: paletteThemeName)) {
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
        // メニュー
        .contextMenu {
            // テーマ名編集
            Button {
                paletteThemeNameEdit(colorPalette: colorPalette)
            } label: {
                HStack {
                    Text("テーマ名編集")
                    Image(systemName: Icon.edit.symbolName())
                }
            }
                        
            // お気に入り
            Button {
                paletteFavoriteUpdate(colorPalette: colorPalette)
            } label: {
                HStack {
                    Text(colorPalette.isFavorite ? "お気に入り解除" : "お気に入り")
                    Image(systemName: Icon.favorite.symbolName())
                }
            }
            
            // 削除
            Button(role: .destructive) {
                paletteDelete(colorPalette: colorPalette)
            } label: {
                HStack {
                    Text("削除")
                        .foregroundStyle(.red)
                    Image(systemName: Icon.trash.symbolName())
                }
            }
        }
    }
    
    // MARK: カラーピッカータブビュー
    @ViewBuilder
    func ColorPaletteTabView() -> some View {
        HStack {
            ForEach(ColorPaletteTab.allCases, id: \.hashValue) { tab in
                Text(tab.tabName())
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(currentTab == tab ? .back : .black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .background {
                        if currentTab == tab {
                            Capsule()
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        } else {
                            Capsule()
                                .stroke(.black)
                        }
                    }
                    .contentShape(Capsule())
                    .animation(.spring(), value: currentTab)
                    .onTapGesture {
                        currentTab = tab
                    }
            }
        }
    }
    
    // MARK: パレットテーマ名編集
    private func paletteThemeNameEdit(colorPalette: ColorPalette) {
        paletteNameEditTarget = colorPalette
        paletteThemeNameText = colorPalette.themeName
        isShowPaletteNameEditAlert = true
    }
    
    // MARK: パレット削除
    private func paletteDelete(colorPalette: ColorPalette) {
        paletteDeleteTarget = colorPalette
        isShowDeleteAlert = true
    }
    
    // MARK: パレットお気に入り更新
    private func paletteFavoriteUpdate(colorPalette: ColorPalette) {
        if colorPalette.isFavorite {
            colorPalette.isFavorite = false
            colorPalette.updatedAt = Date()
        } else {
            colorPalette.isFavorite = true
            colorPalette.updatedAt = Date()
        }
        
        try? context.save()
        success.toggle()
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalSettings())
        .modelContainer(for: [ColorPalette.self, ColorStorage.self])
}
