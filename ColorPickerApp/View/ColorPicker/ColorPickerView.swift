//
//  ColorPickerView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/26.
//

import SwiftUI
import SwiftData
//import SpriteKit


struct ColorPickerView: View {
    @Environment(\.dismiss) private var dismiss
    // バックグランド移ったときやフォアグラウンドに戻ったときを検知
    //@Environment(\.scenePhase) private var scenePhase
    // SwiftData用
    @Environment(\.modelContext) private var context
    // ColorPalette のデータを取得するために宣言
    @Query private var colorPalettes: [ColorPalette]
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    
    // カラーデータ
    @ObservedObject var colorState: ColorPickerViewState
    
    // 選択タブ
    @State var currentTab: ColorPickerTab = .hsb
    // タブエフェクト
    @Namespace private var animation
    
    // カラーデータ保持用
    @State var colorDatasBackup: [ColorData] = []
    // カラーデータ変更を保持するかどうかのアラート
    @State var isShowColorDataChangeAlert: Bool = false
    
    // カラーピッカー画面表示
    @Binding var isShow: Bool
    // カラーパレットId
    @State var colorPaletteId: String?
    
    // パレットテーマ入力アラート表示
    @State var isShowPaletteThemeNameInputAlert: Bool = false
    // パレットテーマ
    @State var paletteThemeName: String = ""

    // 触覚フォードバック
    @State var success: Bool = false
    @State var selection: Bool = false
    
    // トースト
    @Binding var toast: Toast?
    @State private var pickerToast: Toast? = nil
    
    // カラープレビューをドラッグしたかどうか
    //@State var isDragColor: Bool = false
    // バックグラウンド状態かどうか
    //@State var isBackground: Bool = false
    
    // SpriteKit の SKScene を用意
//    var scene: SKScene {
//        // SKScene オブジェクトを作成
//        let scene = ColorPalettePreviewScene(shared: shared,
//                                             colorDatas: $colorState.colorDatas,
//                                             isDrag: $isDragColor,
//                                             selectedColorIndex: $colorState.selectedIndex,
//                                             isBackground: $isBackground)
//        // シーンが View の　frame サイズいっぱいに表示されるようにリサイズ
//        scene.scaleMode = .resizeFill
//        return scene
//    }
    
    var body: some View {
        NavigationStack {
//            SpriteView(scene: scene, options: [.allowsTransparency])
//                .ignoresSafeArea()
//                .zIndex(isDragColor ? 10 : 0)
            
            VStack {
                // MARK: ナビゲーションバー
                CustomNavigationBarContainer (
                    leftContent: {
                        Button {
                            if colorPaletteId == nil {
                                // カラーデータが変更された場合、その変更内容を保持するかアラート確認
                                if colorState.colorDatas != colorDatasBackup {
                                    isShowColorDataChangeAlert = true
                                } else {
                                    dismiss()
                                }
                            } else {
                                colorState.colorDatas = colorDatasBackup
                                dismiss()
                            }
                        } label: {
                            Image(systemName: Icon.close.symbolName())
                        }
                    },
                    centerContent: {
                        if let id = colorPaletteId, 
                            let colorPalette = colorPalettes.first(where: { $0.id == id }) {
                            Text(colorPalette.themeName)
                                .font(.callout)
                        } else {
                            Text("新規")
                        }
                    },
                    rightContent: {
                        if let id = colorPaletteId {
                            // 編集
                            Button {
                                // 編集するパレットを取得
                                let colorPalette = colorPalettes.first(where: { $0.id == id })
                                
                                if let colorPalette = colorPalette {
                                    // パレット取得成功
                                    colorPalette.colorDatas = colorState.colorDatas
                                    colorPalette.updatedAt = Date()
                                    try? context.save()
                                    
                                    isShow = false
                                    success.toggle()
                                    
                                    // トースト表示
                                    toast = Toast(style: .success, message: "パレットを編集しました。")
                                } else {
                                    // パレット取得失敗
                                    isShow = false
                                }
                            } label: {
                                Text("保存")
                            }
                        } else {
                            // 追加
                            Button {
                                // 追加
                                isShowPaletteThemeNameInputAlert = true
                            } label: {
                                Text("作成")
                            }
                        }
                    }
                )
                
                // MARK: カラーコントロール
                VStack {
                    // カラーピッカータブ
                    ColorPickerTabView()
                        .padding(.bottom)
                    
                    // タブに応じて切り替える
                    switch currentTab {
                    case .hsb: // HSB
                        HSBColorPickerView(colorState: colorState, pickerToast: $pickerToast)
                    case .rgb: // RGB
                        RGBColorPickerView(colorState: colorState, pickerToast: $pickerToast)
                    }
                }
                .frame(width: shared.hueBarSize)
                
                Spacer()
                
                Divider()
                
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        Image(systemName: Icon.select.symbolName())
                            .position(x: colorState.selectedIndex == 0 ? (geometry.size.width*0.3)/2 : colorState.selectedIndex == 1 ? (geometry.size.width*0.1/2) + geometry.size.width*0.3 : (geometry.size.width*0.6/2) + geometry.size.width*0.4,
                                      y: 0)
                            .font(.title3)
                            .animation(.spring, value: colorState.selectedIndex)
                            .frame(height: shared.screenHeight/50)

                        ColorPreview(geometry: geometry)
                            .frame(height: shared.screenHeight/9)
                            .shadow(color: Color("Shadow2").opacity(0.20), radius: 10, x: 5, y: 5)
                    }
                }
                .frame(height: shared.screenHeight/7)
                .padding([.top, .horizontal])
            }
        }
        .onAppear {
            // カラーデータ保持
            colorDatasBackup = colorState.colorDatas
        }
        // MARK: 変更保存のアラート
        .alert("配色保持", isPresented: $isShowColorDataChangeAlert) {
            Button("キャンセル", role: .cancel) {
                colorState.colorDatas = colorDatasBackup
                dismiss()
            }
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("現在作成中の配色を保持しますか？")
        }
        // MARK: パレットテーマ入力アラート
        .alert("テーマ名を入力してください。", isPresented: $isShowPaletteThemeNameInputAlert) {
            TextField("テーマ名", text: $paletteThemeName)
                .onChange(of: paletteThemeName) {
                    // 最大桁数6桁を超えた場合、テキストを切り詰める
                    if paletteThemeName.count > 15 {
                        paletteThemeName = String(paletteThemeName.prefix(15))
                    }
                }
            
            Button("キャンセル") {
                isShowPaletteThemeNameInputAlert = false
            }
            Button("OK") {
                context.insert(ColorPalette(colorDatas: colorState.colorDatas,
                                            themeName: paletteThemeName))
                isShowPaletteThemeNameInputAlert = false
                isShow = false
                success.toggle()
                
                // トースト表示
                toast = Toast(style: .success, message: "パレットを作成しました。")
            }
        }
        // MARK: トースト
        .toastView(toast: $pickerToast)
        // MARK: 触覚フィードバック
        .sensoryFeedback(.success, trigger: success)
        .sensoryFeedback(.selection, trigger: selection)
        
//        .onChange(of: scenePhase) {
//            if scenePhase == .background {
//                isBackground = true
//            } else {
//                isBackground = false
//            }
//        }
    }
        
    // MARK: カラーピッカータブビュー
    @ViewBuilder
    func ColorPickerTabView() -> some View {
        HStack {
            ForEach(ColorPickerTab.allCases, id: \.hashValue) { tab in
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
    
    // MARK: カラープレビュー
    @ViewBuilder
    func ColorPreview(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            ForEach(Array(colorState.colorDatas.enumerated()), id: \.offset) { index, color in
                if index == 0 {
                    VStack {
                        Rectangle()
                            .fill(Color(hue: color.hsb.hue,
                                        saturation: color.hsb.saturation,
                                        brightness: color.hsb.brightness))
                            .frame(width: geometry.size.width*0.3)
                            .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                            .onTapGesture {
                                colorState.selectedIndex = 0
                                selection.toggle()
                            }
                        Text("M")
                    }
                } else if index == 1 {
                    VStack {
                        Rectangle()
                            .fill(Color(hue: color.hsb.hue,
                                        saturation: color.hsb.saturation,
                                        brightness: color.hsb.brightness))
                            .frame(width: geometry.size.width*0.1)
                            .onTapGesture {
                                colorState.selectedIndex = 1
                                selection.toggle()
                            }
                        Text("A")
                    }
                } else if index == 2 {
                    VStack {
                        Rectangle()
                            .fill(Color(hue: color.hsb.hue,
                                        saturation: color.hsb.saturation,
                                        brightness: color.hsb.brightness))
                            .frame(width: geometry.size.width*0.6)
                            .cornerRadius(10, corners: [.topRight, .bottomRight])
                            .onTapGesture {
                                colorState.selectedIndex = 2
                                selection.toggle()
                            }
                        Text("B")
                    }
                }
            }
        }
    }
    
//    // MARK: ナビゲーションバービュー（作成）
//    func ColorPickerNavigationBarCreateView() -> some View {
//        CustomNavigationBarContainer (
//            leftContent: {
//                Button {
//                    // カラーデータが変更された場合、その変更内容を保持するかアラート確認
//                    if colorState.colorDatas != colorDatasBackup {
//                        isShowColorDataChangeAlert = true
//                    } else {
//                        dismiss()
//                    }
//                } label: {
//                    Image(systemName: Icon.close.symbolName())
//                        .font(.title)
//                }
//            },
//            centerContent: {
//                Text("カラーピッカー")
//            },
//            rightContent: {
//                NavigationLink(destination: ColorConfirmationView(colorState: colorState)) {
//                    Text("確認")
//                }
//            }
//        )
//    }
    
//    // MARK: ナビゲーションバービュー（編集）
//    func ColorPickerNavigationBarEditView() -> some View {
//        CustomNavigationBarContainer (
//            leftContent: {
//                Button {
//                    dismiss()
//                } label: {
//                    Image(systemName: Icon.back.symbolName())
//                        .font(.title)
//                }
//            },
//            centerContent: {
//                Text("カラーピッカー")
//            },
//            rightContent: {
//                NavigationLink(destination: ColorConfirmationView(colorState: colorState)) {
//                    Text("編集")
//                }
//            }
//        )
//    }
}

#Preview {
    @State var isShowColorPickerView: Bool = true
    @State var toast: Toast? = nil
    
    return VStack {
        ColorPickerView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.5)),
        ColorData(hsb: HSBColor(hue: 0.3, saturation: 0.5, brightness: 0.2)),
        ColorData(hsb: HSBColor(hue: 0.2, saturation: 0.5, brightness: 0.8)),
        ]), isShow: $isShowColorPickerView, toast: $toast)
        .environmentObject(GlobalSettings())
    }
}
