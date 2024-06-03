//
//  ColorPickerView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/26.
//

import SwiftUI

struct ColorPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var colorPickerState: ColorPickerViewState = .init()
    
    @EnvironmentObject private var shared: GlobalSettings
    
    // 角度
    @State private var angle: Double = 0
    
    // 選択タブ
    @State var currentTab: ColorPickerTab = .hsb
    // タブエフェクト
    @Namespace private var animation
    
    // 色
    let sampleColors: [Color] = [.mint, .cyan, .pink, .yellow]
    // 選択カラー
    @State var currentColor: Int = 0
    
    var body: some View {
//        ZStack {
            // 背景色
//            Color(.white)
//                .ignoresSafeArea()
            
        VStack {
            // MARK: ナビゲーションバー
            CustomNavigationBarContainer(
                // 左
                leftContent: {
                    Button {
                        
                    } label: {
                        Image(systemName: Icon.close.symbolName())
                    }
                },
                // 中央
                centerContent: {
                    Text("カラーピッカー")
                },
                // 右
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
                    HSBColorPickerView(colorPickerState: colorPickerState)
                case .rgb: // RGB
                    RGBColorPickerView(colorPickerState: colorPickerState)
                }
            }
            .frame(width: shared.hueBarSize)
            
            Spacer()
            
            // MARK: カラープレビュー
            HStack(spacing: 0) {
                ForEach(sampleColors.indices, id: \.self) { index in
                    Rectangle()
                        .frame(height: shared.screenHeight * 0.1)
                        .offset(x: 0, y: currentColor == index ? -20 : 0)
                        .scaleEffect(currentColor == index ? 1.2 : 1.0)
                        .foregroundStyle(sampleColors[index])
                        .onTapGesture {
                            withAnimation {
                                currentColor = index
                            }
                        }
                }
                
                // カラーが 5つ未満の場合は、追加ボタンを表示
                if sampleColors.count < 5 {
                    // 追加ボタン
                    Button {
                        
                    } label: {
                        ZStack {
                            Rectangle()
                                .frame(height: shared.screenHeight * 0.1)
                                .foregroundStyle(.white)
                            
                            Image(systemName: Icon.plus.symbolName())
                                .font(.title2)
                        }
                    }
                }
            }
            .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 3, y: 3)
            .padding(.horizontal, shared.screenWidth * 0.05)
            .padding(.bottom, shared.screenWidth * 0.05)
        }
    }
//    }
    
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
    ColorPickerView(colorPickerState: .init())
        .environmentObject(GlobalSettings())
}
