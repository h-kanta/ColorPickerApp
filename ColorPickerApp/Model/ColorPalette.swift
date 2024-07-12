//
//  ColorPalette.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class ColorPalette {
    var id: String
    var colorDates: [HSBColor]
    var isFavorite: Bool
    var createdAt: Date
    var updatedAt: Date
    
    init(colorDates: [HSBColor]) {
        self.id = UUID().uuidString
        self.colorDates = colorDates
        self.isFavorite = false
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

