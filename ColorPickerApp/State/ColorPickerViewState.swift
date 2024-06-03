//
//  ColorPickerViewState.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/13.
//

import Foundation
import SwiftUI

class ColorPickerViewModel: ObservableObject {
    @Published var hsbColor: HSBColor = HSBColor(hue: 0, saturation: 1.0, brightness: 1.0)
    @Published var rgbColor: RGBColor = RGBColor(red: 0, green: 0, blue: 0)
    @Published var hexColor: HEXColor = HEXColor(code: "000000")
    @Published var selectedColor: Int = 0
    @Published var currentTab: ColorPickerTab = .rgb
    
    let sampleColors: [Color] = [.mint, .cyan, .pink, .yellow]
    
    // Conversion functions here...
}
