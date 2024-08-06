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
        ZStack {
//            SpriteView(scene: scene, options: [.allowsTransparency])
//                .ignoresSafeArea()
//                .zIndex(isDragColor ? 10 : 0)
            
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
                            context.insert(ColorPalette(colorDatas: colorState.colorDatas))
                            
                            print("aaaaaaaaa")
                            
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
            ForEach(colorState.colorDatas.indices, id: \.self) { index in
                let color = colorState.colorDatas[index]
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
}

#Preview {
    ColorPickerView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.7)),
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.0, brightness: 1.0)),
        ColorData(hsb: HSBColor(hue: 0.9, saturation: 0.5, brightness: 0.7)),
    ]))
        .environmentObject(GlobalSettings())
}
