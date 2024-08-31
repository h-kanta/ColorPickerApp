//
//  ColorStorageMenu.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/08/12.
//

import SwiftUI
import SwiftData

struct ColorStorageMenu: View {
    // グローバル変数
    @EnvironmentObject var shared: GlobalSettings
    // SwiftData用
    @Environment(\.modelContext) private var context
    // カラーストレージ
    @Query private var colorStorages: [ColorStorage]
    
    // カラーデータ
    @ObservedObject var colorState: ColorPickerViewState
    
    // カラーストレージ保存時、同じカラーが存在している場合のアラート
    @State var isShowDuplicateColorAlert: Bool = false
    
    var body: some View {
        Menu() {
            // カラーストレージ保存
            Button(action: addColorStorage) {
                Label("色を保存する", systemImage: Icon.addColorStorage.symbolName())
            }
            
            // カラーストレージ選択
            Button(action: selectedColorStorage) {
                Label("保存した色から選択する", systemImage: Icon.selectColorStorage.symbolName())
            }
        } label: {
            ZStack {
                Circle()
                    .frame(width: shared.hueBarSize * 0.3, height: shared.hueBarSize * 0.3)
                    .foregroundStyle(Color(
                        hue: colorState.colorDatas[colorState.selectedIndex].hsb.hue,
                        saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                        brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness))
                    .cornerRadius(10)
                    .shadow(color: Color("Shadow2").opacity(0.23), radius: 1, x: 4, y: 4)
                    .padding(8)
                
                Image(systemName: Icon.menu.symbolName())
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .background {
                        Circle()
                            .frame(width: shared.hueBarSize * 0.2, height: shared.hueBarSize * 0.2)
                            .foregroundStyle(.black.opacity(0.05))
                    }
                
            }
        }
        // カラーストレージ重複アラート
        .alert("重複カラー", isPresented: $isShowDuplicateColorAlert) {
            
        } message: {
            Text("このカラーは既に保存されています。")
        }
    }
    
    // MARK: カラーストレージ保存処理
    func addColorStorage() {
        // すでに保存しているカラーが存在している場合は、処理終了
        if colorStorages.contains(where: { $0.rgbColor == colorState.colorDatas[colorState.selectedIndex].rgb }) {
            isShowDuplicateColorAlert = true
            return
        }
        // カラー保存
        context.insert(ColorStorage(rgbColor: RGBColor(
            red: colorState.colorDatas[colorState.selectedIndex].rgb.red,
            green: colorState.colorDatas[colorState.selectedIndex].rgb.green,
            blue: colorState.colorDatas[colorState.selectedIndex].rgb.blue)
        ))
    }
    
    // MARK: カラーストレージ選択処理
    func selectedColorStorage() {
        
    }
}

#Preview {
    ColorStorageMenu(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.7)),
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.0, brightness: 1.0)),
        ColorData(hsb: HSBColor(hue: 0.9, saturation: 0.5, brightness: 0.7)),
    ]))
    .environmentObject(GlobalSettings())
}
