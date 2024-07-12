//
//  Icon.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/26.
//

import Foundation

// MARK: アイコン
enum Icon: CaseIterable {
    case back
    case sort
    case menu
    case close
    case favorite
    case copy
    case plus
    case minus
    case trash
}

extension Icon {
    func symbolName() -> String {
        switch self {
        case .back:
            return "arrow.left"
        case .sort:
            return "arrow.up.arrow.down"
        case .menu:
            return "ellipsis"
        case .close:
            return "multiply"
        case .favorite:
            return "heart"
        case .copy:
            return "doc.on.doc"
        case .plus:
            return "plus"
        case .minus:
            return "minus"
        case .trash:
            return "trash"
        }
    }
}
