//
//  ColorSlider.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/16.
//

import SwiftUI

struct ColorSlider: View {
    
    
    @ObservedObject var colorPickerState: ColorPickerViewState
    
    // グラデーションに使用するカラー配列
    let colors: [Color]
    // 画面高さ
    let screenHeight: CGFloat
    // 色相サイズ
    let hueSize: CGFloat
    
    // バーのドラッグジェスチャー
    let colorBarDragGesture: DragGesture
    // サムのドラッグジェスチャー
    let colorThumbDragGesture: DragGesture
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: colors),
                                     startPoint: .leading,
                                     endPoint: .trailing))
                .frame(width: hueSize, height: screenHeight * 0.02)
                .padding(.horizontal)
                .gesture(colorBarDragGesture)
            
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                
                Circle()
                    .stroke(.black.opacity(0.3), lineWidth: 1)
                    .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
            }
            .frame(width: 32, height: 32)
            .offset(x: colorPickerState.hsbColor.brightness * hueSize)
            .gesture(colorThumbDragGesture)
        }
    }
}

#Preview {
    ColorPickerView()
}
