//
//  Sample.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/05.
//

import SwiftUI

import SwiftUI

import SwiftUI

struct Sample: View {
    let sampleColors: [Color] = [.mint, .cyan, .pink, .yellow]
    @State private var currentColor: Int? = nil
    
    let screenHeight: CGFloat = UIScreen.main.bounds.height
    let screenWidth: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        // MARK: プレビューカラー
        HStack(spacing: 0) {
            ForEach(sampleColors.indices, id: \.self) { index in
                Rectangle()
                    .frame(height: screenHeight * 0.1)
                    .offset(y: currentColor == index ? -10 : 0)
                    .foregroundStyle(sampleColors[index])
                    .onTapGesture {
                        withAnimation {
                            currentColor = index
                        }
                    }
            }
            
            // カラーが 5 以上の場合は、追加ボタンを表示
            if sampleColors.count < 5 {
                // 追加ボタン
                ZStack {
                    Rectangle()
                        .frame(height: screenHeight * 0.1)
                        .foregroundStyle(.white)
                    
                    Image(systemName: "plus")
                        .font(.title2)
                }
            }
        }
        .cornerRadius(10)
//        .shadow(color: Color("Shadow1"), radius: 1, x: -4, y: -4)
//        .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 3, y: 3)
        .padding(.horizontal, screenWidth * 0.05)
        .padding(.bottom, screenWidth * 0.05)
    }
}

#Preview {
    Sample()
}
