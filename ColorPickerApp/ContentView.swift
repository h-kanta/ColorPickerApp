//
//  ContentView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/10.
//

import SwiftUI


struct ContentView: View {
    // グローバル変数
    @EnvironmentObject private var shared: GlobalSettings
    
    // カラーデータ
    @StateObject var colorState: ColorPickerViewState = .init(colorDatas: [
        ColorData(rgb: RGBColor(red: 249/255, green: 201/255, blue: 166/255)),
        ColorData(rgb: RGBColor(red: 207/255, green: 232/255, blue: 241/255)),
        ColorData(rgb: RGBColor(red: 254/255, green: 244/255, blue: 244/255)),
    ])
    
    @State var currentTab: Tab = .palette
    
    // カラーピッカービュー表示
    @State var isShowColorPickerView: Bool = false
    
    init() {
        UITabBar.appearance().isHidden = true
        // TabBarAppearanceの設定
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // 背景色
//        appearance.backgroundColor = UIColor(named: "BackColor")
        // 下線（シャドウ）を透明にする
        appearance.shadowColor = .clear
        // 影をつける
//        appearance.shadowColor = UIColor.black.withAlphaComponent(0.3)
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        ZStack {
            TabView(selection: $currentTab) {
//                HomeView()
//                    .tag(Tab.home)
                ColorPaletteView()
                    .tag(Tab.palette)
                    .padding(.bottom, 60)
                ColorStorageView()
                    .tag(Tab.favoriteColor)
                    .padding(.bottom, 60)
//                OptionView()
//                    .tag(Tab.option)
            }
            
            CustomTabBar(currentTab: $currentTab, isShowColorPickerView: $isShowColorPickerView)
                .environmentObject(GlobalSettings())
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .fullScreenCover(isPresented: $isShowColorPickerView) {
            // ここに全画面で表示するモーダルの内容を配置
            ColorPickerView(colorState: colorState, isShow: $isShowColorPickerView)
                .environmentObject(GlobalSettings())
        }
    }
    
}

#Preview {
    ContentView()
        .environmentObject(GlobalSettings())
        .modelContainer(for: [ColorPalette.self, ColorStorage.self])
}
