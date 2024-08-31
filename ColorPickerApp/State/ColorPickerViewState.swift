//
//  ColorPickerViewState.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/13.
//

import Foundation
import SwiftUI

class ColorPickerViewState: ObservableObject {
    @Published var colorDatas: [ColorData]
//    @Published var radians: Double
    @Published var selectedIndex: Int
    //@Published var isDragging: Bool
//    @Published var colorSelectedPosition: CGFloat
//    @Published var showColorPickerView: Bool
    
    @EnvironmentObject private var shared: GlobalSettings
    
    init(colorDatas: [ColorData]) {
        self.colorDatas = colorDatas
        self.selectedIndex = 0
        //self.isDragging = false
//        self.showColorPickerView = false
    }
    
    // MARK: コンバート
    // HSB から RGB に変換
    func HSBToRGB() {
        colorDatas[selectedIndex].rgb = colorDatas[selectedIndex].hsb.toRGB()
    }
    
    // RGB から HSB に変換
    func RGBToHSB() {
        // HSBを取得
        colorDatas[selectedIndex].hsb = colorDatas[selectedIndex].rgb.toHSB()
    }
    
    // RGB から HEX に変換
    func RGBToHEX() {
        colorDatas[selectedIndex].hex = colorDatas[selectedIndex].rgb.toHEX()
    }
    
    // HEX から RGB に変換
    func HEXToRGB() {
        colorDatas[selectedIndex].rgb = colorDatas[selectedIndex].hex.toRGB()
    }
    
    // 数値から % に変換
    func convertToPercentage(_ value: Double) -> String {
        return String(format: "%.0f%%", value * 100)
    }
    
    // HSB、RGBのドラッグ時の現在値(0.0~1.0)を取得
    func GetBarCurrentXLocation(locationX: Double) -> Double {
        let ratio = locationX / shared.hueBarSize

        return min(max(0, ratio), 1)
    }
}
