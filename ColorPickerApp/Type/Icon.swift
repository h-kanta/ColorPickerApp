//
//  Icon.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/26.
//

import Foundation

// MARK: アイコン
enum Icon: CaseIterable {
    // パレット作成
    case paletteCreate
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
    // 選択
    case select
    // カラーストレージ追加
    case addColorStorage
    // カラーストレージ選択
    case selectColorStorage
    // 編集
    case edit
    // トースト：インフォメーション
    case toastInfo
    // トースト：ワーニング
    case toastWarning
    // トースト：成功
    case toastSuccess
    // トースト：エラー
    case toastError
}

extension Icon {
    func symbolName() -> String {
        switch self {
        case .paletteCreate:
            return "plus.square"
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
        case .trash:
            return "trash"
        case .select:
            return "arrow.down.circle"
        case .addColorStorage:
            return "square.and.arrow.down.on.square"
        case .selectColorStorage:
            return "square.and.arrow.up.on.square"
        case .edit:
            return "pencil"
        case .toastInfo:
            return "info.circle.fill"
        case .toastWarning:
            return "exclamationmark.triangle.fill"
        case .toastSuccess:
            return "checkmark.circle.fill"
        case .toastError:
            return "xmark.circle.fill"
        }
        
    }
}
