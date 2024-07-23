//
//  HEXColor.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation

struct HEXColor: Codable, Hashable {
    // hexコード
    var code: String
    
    init(code: String) {
        self.code = code
    }
    
    // MARK: HEX から HSB に変換
    func toHSB() -> HSBColor {
        return HSBColor(hue: 0, saturation: 0, brightness: 0)
    }
    
    // MARK: HEX から RGB に変換
    func toRGB() -> RGBColor {
        return RGBColor(red: 0, green: 0, blue: 0)
    }
}
