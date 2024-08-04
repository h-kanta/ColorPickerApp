//
//  Sample.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/05.
//

import SwiftUI

struct Sample: View {
    
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    // カラー
    var colors: [Color] = [.mint, .orange, .cyan]
    
    var body: some View {
        VStack {
            Spacer()
            
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(colors, id: \.self) { color in
                        if colors[0] == color {
                            Rectangle()
                                .fill(color)
                                .frame(width: geometry.size.width*0.6)
                                .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                        } else if colors[1] == color {
                            Rectangle()
                                .fill(color)
                                .frame(width: geometry.size.width*0.1)
                        } else {
                            Rectangle()
                                .fill(color)
                                .frame(width: geometry.size.width*0.3)
                                .cornerRadius(10, corners: [.topRight, .bottomRight])
                        }
                        
                    }
                }
            }
            .padding()
            .frame(width: shared.screenWidth, height: shared.screenHeight/6)
        }
    }
}

#Preview {
    Sample()
        .environmentObject(GlobalSettings())
}
