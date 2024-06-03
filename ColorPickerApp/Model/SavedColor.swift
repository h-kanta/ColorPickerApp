//
//  FavoriteColor.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation
import SwiftData

@Model
final class SavedColor {
    var hexCode: String
    var createdAt: Date
    var updatedAt: Date
    
    init(hexCode: String) {
        self.hexCode = hexCode
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
