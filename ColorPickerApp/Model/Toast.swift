//
//  Toast.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/09/05.
//

import Foundation

struct Toast: Equatable {
    var style: ToastStyle
    var message: String
    var duration: Double = 3
    var width: Double = .infinity
}
