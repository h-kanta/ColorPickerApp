//
//  ToastView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/09/05.
//

import SwiftUI

struct ToastView: View {
    
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        HStack {
            Image(systemName: style.iconName)
                .foregroundStyle(style.themeColor)
            Text(message)
                .font(.caption)
                .foregroundStyle(.black)
            
            Spacer(minLength: 10)
            
            Button {
                onCancelTapped()
            } label: {
                Image(systemName: Icon.close.symbolName())
                    .foregroundStyle(style.themeColor)
            }
        }
        .padding()
        .frame(minWidth: 0, maxWidth: width)
        .background(.white)
        .cornerRadius(10, corners: .allCorners)
        .overlay (
            Capsule()
                .opacity(0.03)
        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    ToastView(style: ToastStyle.success, message: "テスト") {
        
    }
}
