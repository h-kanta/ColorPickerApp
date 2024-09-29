//
//  CustomNavigationBar.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/30.
//

import SwiftUI

struct CustomNavigationBarContainer<LeftContent: View, CenterContent: View, RightContent: View>: View {
    let leftContent: () -> LeftContent
    let centerContent: () -> CenterContent
    let rightContent: () -> RightContent
    
    var body: some View {
        ZStack {
            HStack {
                // 左
                leftContent()
                    .font(.title)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
                
                Spacer()
                
                // 右
                rightContent()
                    .font(.title)
                    .foregroundStyle(.black)
                    .fontWeight(.bold)
            }
            
            // 中央
            centerContent()
                .frame(maxWidth: .infinity)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
    }
}
