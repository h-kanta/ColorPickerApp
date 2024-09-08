//
//  ToastStyle.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/09/05.
//

import Foundation
import SwiftUI

// MARK: トースト
enum ToastStyle {
    case info
    case warning
    case success
    case error
}

extension ToastStyle {
    // 色
    var themeColor: Color {
        switch self {
        case .info: return .blue
        case .warning: return .orange
        case .success: return .green
        case .error: return .red
        }
    }
    
    // アイコン
    var iconName: String {
        switch self {
        case .info: return Icon.toastInfo.symbolName()
        case .warning: return Icon.toastWarning.symbolName()
        case .success: return Icon.toastSuccess.symbolName()
        case .error: return Icon.toastError.symbolName()
        }
    }
}
