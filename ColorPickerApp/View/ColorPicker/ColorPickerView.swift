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
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    
    // カラーデータ
    @ObservedObject var colorState: ColorPickerViewState
    // パレットインデックス
    var colorPaletteIndex: Int?
    
    // 選択タブ
    @State var currentTab: ColorPickerTab = .hsb
    // タブエフェクト
    @Namespace private var animation
    
    // カラーデータ保持用
    @State var colorDatasBackup: [ColorData] = []
    // カラーデータ変更を保持するかどうかのアラート
    @State var isShowColorDataChangeAlert: Bool = false

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
                            // カラーデータが変更された場合、その変更内容を保持するかアラート確認
                            if colorState.colorDatas != colorDatasBackup && colorPaletteIndex == nil {
                                isShowColorDataChangeAlert = true
                            } else {
                                dismiss()
                            }
                        } label: {
                            Image(systemName: Icon.close.symbolName())
                                .font(.title)
                        }
                    },
                    centerContent: {
                        Text("カラーピッカー")
                    },
                    rightContent: {
                        if let index = colorPaletteIndex {
                            NavigationLink(destination: ColorConfirmationView(colorState: colorState, colorPaletteIndex: index)) {
                                Text("確認")
                            }
                        } else {
                            NavigationLink(destination: ColorConfirmationView(colorState: colorState)) {
                                Text("確認")
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
                        HSBColorPickerView(colorState: colorState)
                    case .rgb: // RGB
                        RGBColorPickerView(colorState: colorState)
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
        // 変更保存のアラート
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
    ColorPickerView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.7)),
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.0, brightness: 1.0)),
        ColorData(hsb: HSBColor(hue: 0.9, saturation: 0.5, brightness: 0.7)),
    ]))
        .environmentObject(GlobalSettings())
}
