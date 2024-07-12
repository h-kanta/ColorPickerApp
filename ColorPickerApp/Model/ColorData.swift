//
//  ColorData.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/07/08.
//

import Foundation

struct ColorData {
    var hsbColor: HSBColor
    var rgbColor: RGBColor
    var hexColor: HEXColor
    var radians: Double
    var isDragging: Bool
    
    init() {
        hsbColor = HSBColor(hue: 0, saturation: 1.0, brightness: 1.0)
        rgbColor = RGBColor(red: 0, green: 0, blue: 0)
        hexColor = HEXColor(code: "000000")
        radians = 0
        isDragging = false
    }
}
