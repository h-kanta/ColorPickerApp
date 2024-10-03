//
//  ColorConfirmationView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/08/019.
//

import SwiftUI
import SwiftData

struct ColorPaletteConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    // トースト
    @State private var toast: Toast? = nil
    
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    
    // カラーデータ
    @ObservedObject var colorState: ColorPickerViewState
    
    // カラーピッカー遷移
    @State var isShowColorPickerView: Bool = false
    
    // カラーパレットインデックス
    var colorPaletteId: String
    // パレットテーマ名
    var paletteThemeName: String
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: ナビゲーションバー
                CustomNavigationBarContainer(
                    leftContent: {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: Icon.back.symbolName())
                        }
                    },
                    centerContent: {
                        Text(paletteThemeName)
                            .font(.callout)
                    },
                    rightContent: {
                        Button {
                            isShowColorPickerView = true
                        } label: {
                            Text("編集")
                        }
                        
                    }
                )
                .padding(.bottom)
                .zIndex(100)
                
                // MARK: カラー配色
                colorPreviewConfirmation()
                    .frame(height: shared.screenHeight/9)
                    .shadow(color: Color("Shadow2").opacity(0.20), radius: 10, x: 5, y: 5)
                    .frame(height: shared.screenHeight/7)
                    .padding(.horizontal)
                
                VStack {
                    ForEach(Array(colorState.colorDatas.enumerated()), id: \.offset) { index, color in
                        Divider()
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(index == 0 ? "Main" : index == 1 ? "Accent" : "Base")
                                    .fontWeight(.bold)
                                
                                Rectangle()
                                    .frame(width: shared.screenWidth/3, height: shared.screenHeight/9)
                                    .foregroundStyle(Color(hue: color.hsb.hue,
                                                           saturation: color.hsb.saturation,
                                                           brightness: color.hsb.brightness))
                                    .cornerRadius(10, corners: .allCorners)
                                    .shadow(color: Color("Shadow2").opacity(0.20), radius: 10, x: 5, y: 5)
                            }
                            .padding(.vertical, shared.screenHeight/50)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("RGB: \(Int(color.rgb.red*255)), \(Int(color.rgb.green*255)), \(Int(color.rgb.blue*255))")
                                Text("HEX: #\(color.hex.code)")
                            }
                            
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $isShowColorPickerView) {
            // ここに全画面で表示するモーダルの内容を配置
            ColorPickerView(colorState: colorState,
                            isShow: $isShowColorPickerView,
                            colorPaletteId: colorPaletteId,
                            toast: $toast)
                .environmentObject(GlobalSettings())
        }
        .toastView(toast: $toast)
    }
    
    // MARK: カラー配色
    @ViewBuilder
    func colorPreviewConfirmation() -> some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                ForEach(Array(colorState.colorDatas.enumerated()), id: \.offset) { index, color in
                    if index == 0 {
                        VStack {
                            Rectangle()
                                .foregroundStyle(Color(hue: color.hsb.hue,
                                                       saturation: color.hsb.saturation,
                                                       brightness: color.hsb.brightness))
                                .frame(width: geometry.size.width*0.3)
                                .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                            
                            Text("M")
                        }
                    } else if index == 1 {
                        VStack {
                            Rectangle()
                                .foregroundStyle(Color(hue: color.hsb.hue,
                                                       saturation: color.hsb.saturation,
                                                       brightness: color.hsb.brightness))
                                .frame(width: geometry.size.width*0.1)
                            
                            Text("A")
                        }
                    } else if index == 2 {
                        VStack {
                            Rectangle()
                                .foregroundStyle(Color(hue: color.hsb.hue,
                                                       saturation: color.hsb.saturation,
                                                       brightness: color.hsb.brightness))
                                .frame(width: geometry.size.width*0.6)
                                .cornerRadius(10, corners: [.topRight, .bottomRight])
                            
                            Text("B")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: ナビゲーションバー（作成）
    
    // MARK: ナビゲーションバー
}



#Preview {
    ColorPaletteConfirmationView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.7)),
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.0, brightness: 1.0)),
        ColorData(hsb: HSBColor(hue: 0.9, saturation: 0.5, brightness: 0.7)),
    ]), colorPaletteId: "", paletteThemeName: "テーマ名")
        .environmentObject(GlobalSettings())
}
