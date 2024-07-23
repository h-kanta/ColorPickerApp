//
//  ColorData.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/07/08.
//

import Foundation

struct ColorData: Codable, Hashable {
    var hsb: HSBColor
    var rgb: RGBColor
    var hex: HEXColor
    
    init(hsb: HSBColor, rgb: RGBColor? = nil, hex: HEXColor? = nil) {
        self.hsb = hsb
        self.rgb = rgb ?? hsb.toRGB() // HSBからRGBへ変換
        self.hex = hex ?? hsb.toHEX() // HSBからHEXへ変換
    }
    
    init(rgb: RGBColor, hsb: HSBColor? = nil, hex: HEXColor? = nil) {
        self.rgb = rgb
        self.hsb = hsb ?? rgb.toHSB() // RGBからHSBへ変換
        self.hex = hex ?? rgb.toHEX() // RGBからHEXへ変換
    }
    
    init(hex: HEXColor, hsb: HSBColor? = nil, rgb: RGBColor? = nil) {
        self.hex = hex
        self.rgb = rgb ?? hex.toRGB() // HEXからRGBへ変換
        self.hsb = hsb ?? hex.toHSB() // HEXからHSBへ変換
    }
}
