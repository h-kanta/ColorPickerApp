//
//  HSBColor.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation

struct HSBColor: Codable, Hashable {
    // 色相
    // 0.0 ~ 1.0
    // (0~360の範囲)
    var hue: Double
    // 彩度
    // 0.0 ~ 1.0
    // (0%（灰色）から100%（純粋な色）までの範囲)
    var saturation: Double
    // 明度
    // 0.0 ~ 1.0
    // (0%（完全な黒）から100%（完全な白）までの範囲)
    var brightness: Double
    // 色相の角度
    var hueRadian: Double
    
    // 色相の角度を HSBColor で管理しようとしているが、ラジアンを計算しないといけない
    // 計算方法を考えるところからスタートーーーーーーーーーーーーーーー
    
    init(hue: Double, saturation: Double, brightness: Double) {
        self.hue = hue
        self.saturation = saturation
        self.brightness = brightness
        
        // 色相からラジアンを計算
        // 色相を0~360の範囲にし、範囲の角度を反対にする
        var angleRad = (360 - (hue * 360)).truncatingRemainder(dividingBy: 360)
        // マイナスの場合は 360 足して調整
        if angleRad < 0 {
            angleRad += 360
        }
        // 角度からラジアンに変換
        hueRadian = (angleRad * .pi) / 180
    }
    
    // MARK: HSB から RGB に変換
    func toRGB() -> RGBColor {
        // 変換用rgb
        var red: Double = 0
        var green: Double = 0
        var blue: Double = 0
        
        // 色相 0~360
        let h: Double = self.hue * 360
        // 彩度 0~255
        let s: Double = self.saturation * 255
        // 明度 0~255
        let b: Double = self.brightness * 255
        
        // 明度に基づく最大の RGB値
        let maxVal: Double = b
        // 彩度と明度を考慮して算出された RGB値
        let minVal: Double = maxVal - ((s / 255) * maxVal)
        
        // 色相の範囲を0~5に変換
        let hueSegment = h / 60.0
        
        // 色相の範囲によって値が変わる
        switch hueSegment {
            // 0〜60
            case 0..<1:
                red = maxVal
                green = (h / 60) * (maxVal - minVal) + minVal
                blue = minVal
            // 60〜120
            case 1..<2:
                red = ((120 - h) / 60) * (maxVal - minVal) + minVal
                green = maxVal
                blue = minVal
            // 120〜180
            case 2..<3:
                red = minVal
                green = maxVal
                blue = ((h - 120) / 60) * (maxVal - minVal) + minVal
            // 180〜240
            case 3..<4:
                red = minVal
                green = ((240 - h) / 60) * (maxVal - minVal) + minVal
                blue = maxVal
            // 240〜300
            case 4..<5:
                red = ((h - 240) / 60) * (maxVal - minVal) + minVal
                green = minVal
                blue = maxVal
            // 300〜360
            default:
                red = maxVal
                green = minVal
                blue = ((360 - h) / 60) * (maxVal - minVal) + minVal
        }
        
        return RGBColor(red: red/255, green: green/255, blue: blue/255)
    }
    
    // MARK: HSB から HEX に変換
    func toHEX() -> HEXColor {
        return HEXColor(code: "000000")
    }
}
