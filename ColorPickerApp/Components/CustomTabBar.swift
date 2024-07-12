//
//  CustomTabBar.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var currentTab: Tab
    @Binding var showColorPicker: Bool
    @State private var scale: Double = 1.0
    
    var body: some View {
        HStack {
            ForEach (Tab.allCases, id: \.hashValue) { tab in
                VStack(spacing: 5) {
                    if Tab.paletteCreate == tab {
                        Image(systemName: tab.symbolName())
                            .font(.title)
//                                .renderingMode(.template)
//                            .resizable()
//                                .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(1.5)
                            .offset(x: 0, y: 10)
                            .onTapGesture {
                                showColorPicker = true
                            }
                    } else {
                        Image(systemName: currentTab == tab ? tab.symbolFillName() : tab.symbolName())
                            .font(.title)
//                                .renderingMode(.template)
//                            .resizable()
//                                .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .scaleEffect(currentTab == tab ? 1.2 : 1.0)
                    }
                    
                    Text(tab.tabName())
                        .font(.caption2)
                        .foregroundColor(currentTab == tab ? .black : .gray)
                }
                .onTapGesture {
                    currentTab = tab
                }
            }
        }
//        .background(Color("BackColor"))
//        .cornerRadius(20, corners: [.topLeft, .topRight])
//        .shadow(color: Color("Shadow2").opacity(0.08), radius: 3, x: 0, y: -4)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
}

#Preview {
    ContentView()
}
