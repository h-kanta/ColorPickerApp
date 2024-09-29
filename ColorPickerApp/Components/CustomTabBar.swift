//
//  CustomTabBar.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import SwiftUI

struct CustomTabBar: View {
    
    @Binding var currentTab: Tab
    @Binding var isShowColorPickerView: Bool
    
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    
    // 触覚フィードバック
    @State private var selection = false
    
    var body: some View {
        HStack {
            ForEach (Tab.allCases, id: \.hashValue) { tab in
                    if Tab.paletteCreate == tab {
                        // カラーパレット作成アイコン
                        Image(systemName: tab.symbolName())
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .scaleEffect(1.2)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isShowColorPickerView = true
                                selection.toggle()
                            }
                    } else {
                        VStack(spacing: 7) {
                            Image(systemName: currentTab == tab ? tab.symbolFillName() : tab.symbolName())
                                .font(.title3)
                                .frame(maxWidth: .infinity)
                                .scaleEffect(currentTab == tab ? 1.2 : 1.0)
                            
                            Text(tab.tabName())
                                .font(.caption2)
                                .foregroundColor(currentTab == tab ? .black : .gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            currentTab = tab
                            selection.toggle()
                        }
                    }
            }
        }
        .frame(height: 49)
        .padding(.horizontal)
        .frame(maxWidth: 600)
        .sensoryFeedback(.selection, trigger: selection)
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalSettings())
}
