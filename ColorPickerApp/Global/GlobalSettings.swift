//
//  GlobalSettings.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/26.
//

import Foundation
import SwiftUI

// MARK: 共通変数
class GlobalSettings: ObservableObject {
    // 画面横幅
    @Published var screenWidth: CGFloat
    // 画面縦幅
    @Published var screenHeight: CGFloat
    // 色相サイズ
    @Published var hueBarSize: CGFloat = 0
    
    init() {
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        
        if UIDevice.current.userInterfaceIdiom == .phone {
           // 使用デバイスがiPhoneの場合
            hueBarSize = UIScreen.main.bounds.width * 0.65
        } else if UIDevice.current.userInterfaceIdiom == .pad {
           // 使用デバイスがiPadの場合
            hueBarSize = UIScreen.main.bounds.width * 0.55
        }
    }
}
