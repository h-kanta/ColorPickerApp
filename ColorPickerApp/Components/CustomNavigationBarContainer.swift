//
//  CustomNavigationBar.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/30.
//

import SwiftUI

struct CustomNavigationBarContainer<Content: View>: View {
    let leftContent: Content
    let centerContent: Content
    let rightContent: Content
    
    var body: some View {
        ZStack {
            HStack {
                // 左
                leftContent
                    .font(.title)
                    .foregroundStyle(.black)
                
                // 右
                rightContent
                    .font(.title)
                    .foregroundStyle(.black)
            }
            
            // 中央
            centerContent
                .frame(maxWidth: .infinity)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    CustomNavigationBar2()
//}
