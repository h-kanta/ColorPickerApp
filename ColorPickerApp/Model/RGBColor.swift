//
//  RGBColor.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation

struct RGBColor {
    // Red
    // 0.0~1.0の範囲
    var red: Double
    // Green
    // 0.0~1.0の範囲
    var green: Double
    // Blue
    // 0.0~1.0の範囲
    var blue: Double
    
    // テキスト用
    // Red
//    var redText: String
    // Green
//    var greenText: String
    // Blue
//    var blueText: String
    
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        
//        self.redText = (red * 255).description
//        self.greenText = (green * 255).description
//        self.blueText = (blue * 255).description
    }
    
    // MARK: RGB から HSB に変換
    func ToHSB() -> HSBColor {
        // RGB
        let (red, green, blue) = (self.red, self.green, self.blue)

        // RGBの最大値
        let maxValue = max(red, green, blue)
        // RGBの最小値
        let minValue = min(red, green, blue)
        // 最大値と最小値の差
        let delta = maxValue - minValue

        // 色相
        var hue: Double = 0
        // 彩度
        var saturation: Double = 0
        // 明度
        let brightness = maxValue
        
        if maxValue != 0 {
            saturation = delta / maxValue
        }

        // deltaが 0 の場合は、RGBの値がすべて等しいことになる
        if delta != 0 {
            switch maxValue {
            case red:
                hue = ((green - blue) / delta).truncatingRemainder(dividingBy: 6)
            case green:
                hue = ((blue - red) / delta) + 2
            case blue:
                hue = ((red - green) / delta) + 4
            default:
                hue = 0
            }

            hue *= 60
            if hue < 0 {
                hue += 360
            }
        } else {
            hue = 0
        }

        return HSBColor(hue: hue / 360, saturation: saturation, brightness: brightness)
    }

//    func ToHSB(rgbColor: RGBColor) -> HSBColor {
//        // HSB
//        var hue: Double = 0
//        var saturation: Double = 0
//        var brightness: Double = 0
//        
//        // RGB
//        let (r, g, b) = (rgbColor.red*255, rgbColor.green*255, rgbColor.blue*255)
//        // 最大値
//        let maxValue = max(r, g, b)
//        // 最小値
//        let minValue = min(r, g, b)
//        
//        // 色相を求める
//        // 3つとも同じ値の場合は、色相0
//        if ((r == g) && (g == b)) {
//            hue = 0
//        } else {
//            switch maxValue {
//            case r:
//                hue = 60 * ((g - b) / (maxValue - minValue))
//            case g:
//                hue = 60 * ((b - r) / (maxValue - minValue)) + 120
//            case b:
//                hue = 60 * ((r - b) / (maxValue - minValue)) + 240
//            default:
//                hue = 0
//            }
//        }
//        
//        // マイナス値の場合は、360を足す
//        if hue < 0 {
//            hue += 360
//        }
//        
//        // 彩度を求める
//        saturation = (maxValue - minValue) / maxValue
//                
//        // 明度を求める
//        brightness = maxValue
//        
//        return HSBColor(hue: hue/360, saturation: saturation, brightness: brightness/255)
//    }
    
    // MARK: RGB から HEX に変換
    func ToHEX() -> HEXColor {
        // 変換用にred, green, blue を配列に格納
        let rgb: [Double] = [self.red*255, self.green*255, self.blue*255]
        // red, green, blurを整数に変換し、その値を16進数の形式にフォーマット
        // 生成した 16進数の文字を連結
        // "%02X"：数値を2桁の16進数で表現し、必要に応じて0で埋めることを指定
        return HEXColor(code: rgb.map { String(format: "%02X", Int($0)) }.joined())
    }
}
