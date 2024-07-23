//
//  ContentView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/10.
//

import SwiftUI


struct ContentView: View {
    
    // カラーデータ
    @StateObject var colorState: ColorPickerViewState = .init(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.5)),
        ColorData(hsb: HSBColor(hue: 0.3, saturation: 0.5, brightness: 0.2))
    ])
    
    @State var currentTab: Tab = .home
    @State var showColorPickerView: Bool = false
    
    init() {
//        UITabBar.appearance().isHidden = true
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
        
        //@StateObject var colorPickerState: ColorPickerViewState = .init()
    }
    
    var body: some View {
        ZStack {
//            Rectangle()
//                .frame(width: 100, height: 100)
//                .cornerRadius(10)
//                .shadow(color: Color("Shadow1"), radius: 3, x: -5, y: -5)
//                .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 5, y: 5)
//                .foregroundStyle(Color("MainColor"))
            
            TabView(selection: $currentTab) {
                HomeView()
                    .tag(Tab.home)
                
                ColorPaletteView()
                    .tag(Tab.palette)
                
//                Text("パレット作成")
//                    .tag(Tab.paletteCreate)
                
                StorageColorView()
                    .tag(Tab.favoriteColor)
                
                OptionView()
                    .tag(Tab.option)
            }
//            .background(GeometryReader { geometry in
//                Color.clear.onAppear {
//                    print("TabView height: \(geometry.size.height)")
//                }
//            })
            
            CustomTabBar(currentTab: $currentTab, showColorPicker: $showColorPickerView)
        }
//        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showColorPickerView) {
            // ここに全画面で表示するモーダルの内容を配置
            ColorPickerView(colorState: colorState)
                .environmentObject(GlobalSettings())
        }
        .onAppear {
            print(colorState)
        }
        
    }
    
}

#Preview {
    ContentView()
}
