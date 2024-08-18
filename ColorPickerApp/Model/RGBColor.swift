//
//  RGBColor.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation

struct RGBColor: Codable, Hashable {
    // Red
    // 0.0~1.0の範囲
    var red: Double
    // Green
    // 0.0~1.0の範囲
    var green: Double
    // Blue
    // 0.0~1.0の範囲
    var blue: Double
    
    // コピー用
    var redCopy: Double
    var greenCopy: Double
    var blueCopy: Double
    
    // テキストフィールド出力用に使用（0~255）
    // Red
    var redByteScaleValue: String
    // Green
    var greenByteScaleValue: String
    // Blue
    var blueByteScaleValue: String
    
    init(red: Double, green: Double, blue: Double) {
        self.red = red
        self.green = green
        self.blue = blue
        
        self.redCopy = red
        self.greenCopy = green
        self.blueCopy = blue

        self.redByteScaleValue = Int(red*255).description
        self.greenByteScaleValue = Int(green*255).description
        self.blueByteScaleValue = Int(blue*255).description
    }
    
    // MARK: RGB から HSB に変換
    func toHSB() -> HSBColor {
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
    
    // MARK: RGB から HEX に変換
    func toHEX() -> HEXColor {
        // 変換用にred, green, blue を配列に格納
        let rgb: [Double] = [self.red*255, self.green*255, self.blue*255]
        // red, green, blurを整数に変換し、その値を16進数の形式にフォーマット
        // 生成した 16進数の文字を連結
        // "%02x"：数値を2桁の16進数で表現し、必要に応じて0で埋めることを指定
        return HEXColor(code: rgb.map { String(format: "%02x", Int($0)) }.joined())
    }
}
