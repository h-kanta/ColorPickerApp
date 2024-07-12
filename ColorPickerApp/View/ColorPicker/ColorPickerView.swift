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
    
    @StateObject var colorPickerState: ColorPickerViewState = .init()
    
    @EnvironmentObject private var shared: GlobalSettings
    
    // 色相円の角度
    @State private var angle: Double = 0
    
    // 選択タブ
    @State var currentTab: ColorPickerTab = .hsb
    // タブエフェクト
    @Namespace private var animation
    
    // 色
    @State var sampleColors: [Color] = [Color(hue: 0.4, saturation: 0.7, brightness: 0.3), .cyan, .pink, .yellow]
    // 選択中のプレビューカラー
    @State var selectedColorIndex: Int = 0
    // プレビューカラー位置
    @State var dragOffset: CGSize = CGSize()
    @State var dragPosition: CGPoint = CGPoint()
    // ドラッグ中のプレビューカラー
    @State var draggedColor: Int?
    // トラッシュ
    @State var isTrash: Bool = false
    // トラッシュの位置
    @State var trashPosition: CGSize = CGSize()
    
    @State var isDragColor: Bool = false
    
    // SpriteKit の SKScene を用意
    var scene: SKScene {
        // SKScene オブジェクトを作成
        let scene = ColorPalettePreviewScene(shared: shared,
                                             colors: $sampleColors,
                                             isDrag: $isDragColor,
                                             selectedColorIndex: $selectedColorIndex)
        // シーンが View の　frame サイズいっぱいに表示されるようにリサイズ
        scene.scaleMode = .resizeFill
        return scene
    }
    
    var body: some View {
        ZStack {
            // 背景色
            //            Color(.white)
            //                .ignoresSafeArea()
            
            SpriteView(scene: scene, options: [.allowsTransparency])
                .ignoresSafeArea()
                .zIndex(isDragColor ? 10 : 0)
            
//            ZStack {
//                if draggedColor != nil {
//                    Color(.black).opacity(0.6)
//                        .ignoresSafeArea()
//                }
//                
//                // MARK: カラーゴミ箱
//                if draggedColor != nil {
//                    GeometryReader { geometry in
//                        Circle()
//                            .frame(width: shared.screenWidth/5, height: shared.screenWidth/5)
//                            .foregroundStyle(isTrash ? .red.opacity(0.4) : .white.opacity(0.8))
//                            .overlay {
//                                Image(systemName: Icon.trash.symbolName())
//                                    .font(.title)
//                                    .fontWeight(.bold)
//                                    .foregroundStyle(isTrash ? .red.opacity(0.8) : .black)
//                            }
//                            .position(x: shared.screenWidth/2, y: shared.screenHeight/1.5)
//                    }
//                }
//                
//                // MARK: カラーパレットプレビュー
//                HStack {
//                    ForEach(sampleColors.indices, id: \.self) { index in
//                        GeometryReader { geometry in
//                            Rectangle()
//                                .frame(width: shared.screenWidth/7,
//                                       height: shared.screenWidth/5.5)
//                                .scaleEffect(CGSize(width: draggedColor == index ? 1.3 : 1.0,
//                                                    height: draggedColor == index ? 1.3 : 1.0))
//                                .foregroundStyle(isTrash ?
//                                                 sampleColors[index].opacity(0.7) : sampleColors[index])
//                                // 選択中のカラー
//                                .background {
//                                    if selectedColor == index {
//                                        Rectangle()
//                                            .frame(width: shared.screenWidth/5,
//                                                   height: shared.screenWidth/4)
//                                            .foregroundStyle(sampleColors[index].opacity(0.3))
//                                            .matchedGeometryEffect(id: "COLOR", in: animation)
//                                    }
//                                }
//                                .onTapGesture {
//                                    withAnimation {
//                                        selectedColor = index
//                                        print(shared.screenWidth, shared.screenHeight)
//                                        print(geometry.frame(in: .global))
//                                    }
//                                }
//                                .position(draggedColor == index ?
//                                          CGPoint(x: dragPosition.x,
//                                                  y: dragPosition.y) :
//                                          CGPoint(x: shared.screenWidth/7,
//                                                  y: shared.screenHeight/1.15))
////                                .offset(draggedColsor == index ? dragOffset : .zero)
//                                .gesture(ColorGesture(index, geometry.frame(in: .global).origin))
//                        }
//                    }
//                    
//                    // カラーが 5つ未満の場合は、追加ボタンを表示
//                    if sampleColors.count < 5 {
//                        // 追加ボタン
//                        Button {
//                            withAnimation(.spring) {
//                                sampleColors.append(.orange)
//                            }
//                        } label: {
//                            Rectangle()
//                                .frame(width: shared.screenWidth/7,
//                                       height: shared.screenWidth/6)
//                                .foregroundStyle(.white)
//                                .overlay {
//                                    Image(systemName: Icon.plus.symbolName())
//                                }
//                        }
//                    }
//                }
//                .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 3, y: 3)
////                .padding([.horizontal, .bottom], shared.screenWidth * 0.04)
//            }
//            .zIndex(draggedColor != nil ? 30 : 0)
//            .frame(width: .infinity, height: .infinity)
//            .ignoresSafeArea()
            
            
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
                        HSBColorPickerView(colorPickerState: colorPickerState, 
                                           colors: $sampleColors,
                                           selectedColorIndex: $selectedColorIndex)
                    case .rgb: // RGB
                        RGBColorPickerView(colorPickerState: colorPickerState)
                    }
                }
                .frame(width: shared.hueBarSize)
                
                Spacer()
            }
            
            // MARK: カラーパレットプレビュー
//            SpriteView(scene: scene)
        }
    }
//    }
    
    // MARK: カラージェスチャー
    func ColorGesture(_ index: Int, _ globalPosition: CGPoint) -> some Gesture {
        // 長押し時
        LongPressGesture(minimumDuration: 0.5)
            .onEnded { value in
                withAnimation {
                    draggedColor = index
                }
            }
        
            // ドラッグ時
            .simultaneously(
                with: DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        // ドラッグしているカラーのみ移動
                        // 移動すると中央に調整
                        if draggedColor != nil {
                            dragOffset = CGSize(
                                width: value.location.x - value.startLocation.x,
                                height: value.location.y - value.startLocation.y
                            )
                            
                            dragPosition = value.location
                        }
                        
                        print(dragPosition)
                        print(shared.screenWidth, shared.screenHeight)
                        
                        if isCollisionBetweenCircleAndRect(
                            circleCenterX: (shared.screenWidth/2) + (shared.screenWidth/5)/2,
                            circleCenterY: (shared.screenWidth/1.5) + (shared.screenWidth/5)/2,
                            radius: Double((shared.screenWidth/5)/2),
                            rectCenterX: globalPosition.x,
                            rectCenterY: globalPosition.y,
                            width: shared.screenWidth/7,
                            height: shared.screenHeight/6) {
                            print("衝突！！！！")
                        }
                    }
                    .onEnded { _ in
                        withAnimation(.spring) {
                            dragOffset = .zero
                            draggedColor = nil
                            
                        }
                    }
            )
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
    
    // カラープレビューとゴミ箱アイコンの衝突判定
    func isCollisionBetweenCircleAndRect(circleCenterX cx: Double, circleCenterY cy: Double, radius: Double, rectCenterX rx: Double, rectCenterY ry: Double, width: Double, height: Double) -> Bool {
        // 矩形の各辺の最小値・最大値を計算
        let rectLeft = rx - width / 2
        let rectRight = rx + width / 2
        let rectTop = ry + height / 2
        let rectBottom = ry - height / 2

        // 円の中心から矩形の最近点までの x 座標と y 座標を求める
        let closestX = max(rectLeft, min(cx, rectRight))
        let closestY = max(rectBottom, min(cy, rectTop))

        // 最近点との距離を計算
        let distanceX = cx - closestX
        let distanceY = cy - closestY

        // 距離が円の半径以下なら衝突している
        return (distanceX * distanceX + distanceY * distanceY) <= (radius * radius)
    }
}

#Preview {
    ColorPickerView(colorPickerState: .init())
        .environmentObject(GlobalSettings())
}
