//
//  ColorPalette.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation
import SwiftData

@Model
final class ColorPalette {
    var id: String
    var colors: [HSBColor]
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(colors: [HSBColor]) {
        self.id = UUID().uuidString
        self.colors = colors
        self.isFavorite = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
