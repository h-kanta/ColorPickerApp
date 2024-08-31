//
//  ColorConfirmationView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/08/06.
//

import SwiftUI
import SwiftData

struct ColorConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    // SwiftData 用
    @Environment(\.modelContext) private var context
    // ColorPalette のデータを取得するために宣言
    @Query private var colorPalettes: [ColorPalette]
    
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    
    // カラーデータ
    @ObservedObject var colorState: ColorPickerViewState
    // カラーピッカー遷移
    @State var isShowColorPickerView: Bool = false
    
    // カラーパレットインデックス
    @State var colorPaletteIndex: Int?
    
    // パレットテーマ入力アラート表示
    @State var isShowPaletteThemeNameInputAlert: Bool = false
    // パレットテーマ
    @State var paletteThemeName: String = ""
    
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
                                .font(.title)
                        }
                    },
                    centerContent: {
                        Text("配色確認")
                    },
                    rightContent: {
                        Button {
                            if let index = colorPaletteIndex {
                                // 編集
                                colorPalettes[index].colorDatas = colorState.colorDatas
                                colorPalettes[index].updatedAt = Date()
                                try? context.save()
                                
//                                colorState.showColorPickerView = false
                            } else {
                                // 追加
                                isShowPaletteThemeNameInputAlert = true
                            }
                        } label: {
                            Text("完了")
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
        // パレットテーマ入力アラート
        .alert("テーマ名を入力してください。", isPresented: $isShowPaletteThemeNameInputAlert) {
            TextField("テーマ名", text: $paletteThemeName)
            
            Button("キャンセル", role: .cancel) {
                isShowPaletteThemeNameInputAlert = false
            }
            Button("OK") {
                context.insert(ColorPalette(colorDatas: colorState.colorDatas,
                                            themeName: paletteThemeName))
                isShowPaletteThemeNameInputAlert = false
            }
        }
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
    ColorConfirmationView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.7)),
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.0, brightness: 1.0)),
        ColorData(hsb: HSBColor(hue: 0.9, saturation: 0.5, brightness: 0.7)),
    ]))
        .environmentObject(GlobalSettings())
}
