//
//  ColorPalette.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import SwiftData
import SwiftUI

@Model
final class ColorPalette {
    var id: String
    var themeName: String
    var colorDatas: [ColorData]
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(colorDatas: [ColorData], themeName: String) {
        self.id = UUID().uuidString
        self.themeName = themeName
        self.colorDatas = colorDatas
        self.isFavorite = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
