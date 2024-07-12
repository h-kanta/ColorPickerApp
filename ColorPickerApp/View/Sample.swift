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
    @State var sampleColors: [Color] = [.mint, .cyan, .pink, .yellow, .pink]
//    @State var sampleColorAll: [Color] = [.mint, .cyan, .pink, .yellow, .pink]
    @State private var currentColor1: Int = 0
//    @State private var currentColor2: Int = 0
    
    @EnvironmentObject private var shared: GlobalSettings
    
    var body: some View {
        ZStack {
            GeometryReader { geometryProxy in
                Button {
                    print(geometryProxy.frame(in: .named("container")).origin.x,
                          geometryProxy.frame(in: .named("container")).origin.y)
                } label: {
                    Rectangle()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.red)
                        .coordinateSpace(.named("container"))
                }
                
                .position(x: 100, y: 100)
            }
            
            
            
        }
    }
}

#Preview {
    Sample()
        .environmentObject(GlobalSettings())
}
