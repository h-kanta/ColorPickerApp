//
//  ColorPickerView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/26.
//

import SwiftUI
import SpriteKit

struct ColorPickerView: View {
    @Environment(\.dismiss) var dismiss
    // バックグランド移ったときやフォアグラウンドに戻ったときを検知
    @Environment(\.scenePhase) private var scenePhase
    // SwiftData用
    @Environment(\.modelContext) private var context
    
    // カラーデータ
    @ObservedObject var colorState: ColorPickerViewState
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    
    // 選択タブ
    @State var currentTab: ColorPickerTab = .hsb
    // タブエフェクト
    @Namespace private var animation
    
    // カラープレビューをドラッグしたかどうか
    @State var isDragColor: Bool = false
    // バックグラウンド状態かどうか
    @State var isBackground: Bool = false
    
    // SpriteKit の SKScene を用意
    var scene: SKScene {
        // SKScene オブジェクトを作成
        let scene = ColorPalettePreviewScene(shared: shared,
                                             colorDatas: $colorState.colorDatas,
                                             isDrag: $isDragColor,
                                             selectedColorIndex: $colorState.selectedIndex,
                                             isBackground: $isBackground)
        // シーンが View の　frame サイズいっぱいに表示されるようにリサイズ
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea()
                .zIndex(isDragColor ? 10 : 0)
            
            VStack {
                // MARK: ナビゲーションバー
                CustomNavigationBarContainer(
                    leftContent: {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: Icon.close.symbolName())
                                .font(.title)
                        }
                    },
                    centerContent: {
                        Text("カラーピッカー")
                    },
                    rightContent: {
                        Button {
                            // カラーパレットに追加
                            context.insert(ColorPalette(colorDates: colorState.colorDatas))
                            
                            dismiss()
                        } label: {
                            Text("作成")
                        }
                    }
                )
                .padding(.bottom)
                
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
            }
        }
        .onChange(of: scenePhase) {
            if scenePhase == .background {
                isBackground = true
            } else {
                isBackground = false
            }
        }
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
}

#Preview {
    ColorPickerView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.7)),
        ColorData(hsb: HSBColor(hue: 0.9, saturation: 0.5, brightness: 0.7))
    ]))
        .environmentObject(GlobalSettings())
}
