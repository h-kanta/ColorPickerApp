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
    var colorDatas: [ColorData]
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(colorDatas: [ColorData]) {
        self.id = UUID().uuidString
        self.colorDatas = colorDatas
        self.isFavorite = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

