//
//  Icon.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/26.
//

import Foundation

// MARK: アイコン
enum Icon: CaseIterable {
    // 戻る
    case back
    // 並び替え
    case sort
    // メニュー
    case menu
    // 閉じる
    case close
    // お気に入り
    case favorite
    // コピー
    case copy
    // 追加
    case plus
    // ゴミ箱
    case trash
    // ストレージカラー追加
    case addStorageColor
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
            return "plus.circle"
        case .trash:
            return "trash"
        case .addStorageColor:
            return "plus.square.fill.on.square.fill"
        }
    }
}
