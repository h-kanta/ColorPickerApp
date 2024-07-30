//
//  FavoriteColor.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation
import SwiftData

@Model
final class ColorStorage {
    var rgbColor: RGBColor
    var createdAt: Date
    var updatedAt: Date
    
    init(rgbColor: RGBColor) {
        self.rgbColor = rgbColor
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
