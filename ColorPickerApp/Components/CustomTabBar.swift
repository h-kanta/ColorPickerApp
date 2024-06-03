//
//  CustomTabBar.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var currentTab: Tab
    @State private var scale: Double = 1.0
    
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach (Tab.allCases, id: \.hashValue) { tab in
                    VStack(spacing: 8) {
                        if Tab.paletteCreate == tab {
                            Image(systemName: tab.symbolName())
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 35, height: 35)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 20)
                        } else {
                            Image(systemName: currentTab == tab ? tab.symbolFillName() : tab.symbolName())
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .frame(maxWidth: .infinity)
                                .scaleEffect(currentTab == tab ? 1.2 : 1.0)
                        }
                        
                        Text(tab.tabName())
                            .font(.caption2)
                            .foregroundColor(currentTab == tab ? .black : .gray)
                    }
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 1)) {
                            currentTab = tab
                        }
                    }
                }
            }
            .background(Color("MainColor"))
            .cornerRadius(10)
            .shadow(color: Color("Shadow1"), radius: 5, x: 0, y: -5)
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

#Preview {
    ContentView()
}
