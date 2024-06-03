//
//  Tab.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation


// MARK: 下部タブ
enum Tab: CaseIterable {
    case home
    case palette
    case paletteCreate
    case favoriteColor
    case option
}

extension Tab {
    func tabName() -> String {
        switch self {
        case .home:
            return "ホーム"
        case .palette:
            return "配色"
        case .paletteCreate:
            return ""
        case .favoriteColor:
            return "保存済み色"
        case .option:
            return "設定"
        }
    }
    
    
    func symbolName() -> String {
        switch self {
        case .home:
            return "house"
        case .palette:
            return "paintpalette"
        case .paletteCreate:
            return "plus.square"
        case .favoriteColor:
            return "square.grid.2x2"
        case .option:
            return "gearshape"
        }
    }
    
    
    func symbolFillName() -> String {
        switch self {
        case .home:
            return "house.fill"
        case .palette:
            return "paintpalette.fill"
        case .paletteCreate:
            return "plus.square"
        case .favoriteColor:
            return "square.grid.2x2.fill"
        case .option:
            return "gearshape.fill"
        }
    }
}

// MARK: カラーピッカー用のタブ
enum ColorPickerTab: CaseIterable {
    case hsb
    case rgb
}

extension ColorPickerTab {
    func tabName() -> String {
        switch self {
        case .hsb:
            return "HSB"
        case .rgb:
            return "RGB"
        }
    }
}
