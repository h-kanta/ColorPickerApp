//
//  View.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/09/06.
//

import SwiftUI

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
