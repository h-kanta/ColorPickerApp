//
//  ColorPickerViewState.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/13.
//

import Foundation
import SwiftUI

class ColorPickerViewState: ObservableObject {
    @Published var hsbColor: HSBColor
    @Published var rgbColor: RGBColor
    @Published var hexColor: HEXColor
    @Published var radians: Double
    @Published var isDragging: Bool
    
    // カラー情報をどのようにもつか、
    // SwiftData とどのように連携するかを考える
    
    @EnvironmentObject private var shared: GlobalSettings
    
    init() {
        hsbColor = HSBColor(hue: 0, saturation: 1.0, brightness: 1.0)
        rgbColor = RGBColor(red: 0, green: 0, blue: 0)
        hexColor = HEXColor(code: "000000")
        radians = 0
        isDragging = false
    }
    
    // MARK: コンバート
    // HSB から RGB に変換
    func HSBToRGB() {
         rgbColor = hsbColor.ToRGB()
    }
    
    // RGB から HSB に変換
    func RGBToHSB() {
        // HSBを取得
        hsbColor = rgbColor.ToHSB()
        // 色相を0~360の範囲にし、範囲の角度を反対にする
        var angleRad = (360 - (hsbColor.hue * 360)).truncatingRemainder(dividingBy: 360)
                
        // マイナスの場合は 360 足して調整
        if angleRad < 0 {
            angleRad += 360
        }
        
        // 角度からラジアンに変換
        radians = (angleRad * .pi) / 180
    }
    
    // RGB から HEX に変換
    func RGBToHEX() {
        hexColor = rgbColor.ToHEX()
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
