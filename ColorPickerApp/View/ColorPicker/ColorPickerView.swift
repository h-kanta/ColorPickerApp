//
//  ColorPickerView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/26.
//

import SwiftUI

struct ColorPickerView: View {
    @Environment(\.dismiss) var dismiss
    
    // HSB
    @State var hsbColor: HSBColor = .init(hue: 0, saturation: 1.0, brightness: 1.0)
    // RGB
    @State var rgbColor: RGBColor = .init(red: 0, green: 0, blue: 0)
    // HEX
    @State var hexColor: HEXColor = .init(code: "000000")
    
    // 画面横幅
    private let screenWidth: CGFloat = UIScreen.main.bounds.width
    // 画面縦幅
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    // 色相サイズ
    private let hueSize: CGFloat = UIScreen.main.bounds.width * 0.65
    
    // ラジアン
    @State private var radians: Double = 0
    // 角度
    @State private var angle: Double = 0
    
    // 彩度位置
    @State private var saturationPositionValue: Double = 0
    
    // 明度位置
    @State private var brightnessPositionValue: Double = 0
    
    // 選択タブ
    @State var currentTab: ColorPickerTab = .rgb
    // エフェクト
    @Namespace private var animation
    
    // 色
    let sampleColors: [Color] = [.mint, .cyan, .pink, .yellow]
    // 選択カラー
    @State var currentColor: Int = 0
    
    var body: some View {
        ZStack {
            // 背景色
            Color("BackColor")
                .ignoresSafeArea()
            
            VStack {
                // ナビゲーションバー
                CustomNavigationBar(headerTitle: "カラーピッカー", leftImageSystemName: Icon.close.symbolName(), dismiss: dismiss)
                    .padding(.bottom)
                
                // MARK: 色相
                ZStack {
                    Circle()
                        .stroke(
                            AngularGradient(gradient: Gradient(colors: [
                                Color(hue: 1.0, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.9, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.8, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.7, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.6, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.5, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.4, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.3, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.2, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.1, saturation: 1.0, brightness: 1.0),
                                Color(hue: 0.0, saturation: 1.0, brightness: 1.0),
                            ]), center: .center)
                        , lineWidth: 12)
                        .frame(width: hueSize, height: hueSize)
                        .shadow(color: Color("Shadow1"), radius: 5, x: 5, y: 5)
                        .shadow(color: Color("Shadow1"), radius: 5, x: -5, y: -5)
                        .gesture(dragGesture)
                    
                    // 色相選択位置
                    Circle()
                        .frame(width: hueSize * 0.2, height: hueSize * 0.2)
                        .foregroundStyle(Color(hue: hsbColor.hue,
                                               saturation: hsbColor.saturation,
                                               brightness: hsbColor.brightness))
                        .shadow(color: Color("Shadow1"), radius: 3, x: -3, y: -3)
                        .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 3, y: 3)
                        .offset(x: cos(radians) * hueSize/2, y: sin(radians) * hueSize/2)
                        .gesture(dragGesture2)
                        //.rotationEffect(.init(degrees: angle))
    //                    .gesture(DragGesture(minimumDistance: 0)
    //                        .onChanged(onChanged(value:))
    //                    )
                    
                    VStack {
                        // MARK: プレビュー
                        Rectangle()
                            .frame(width: hueSize * 0.3, height: hueSize * 0.3)
                            .foregroundStyle(Color(hue: hsbColor.hue,
                                                   saturation: hsbColor.saturation,
                                                   brightness: hsbColor.brightness))
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow1"), radius: 1, x: -4, y: -4)
                            .shadow(color: Color("Shadow2").opacity(0.23), radius: 1, x: 4, y: 4)
                            .padding(8)
                        
                        // MARK: HEX
                        HStack {
//                            Text("# \(hexColor.code)")
//                                .font(.title3)
//                                .fontWeight(.bold)
//                                .padding(8)
//                                .background(.back)
//                                .cornerRadius(10, corners: [.topLeft, .bottomLeft])
//                                .shadow(color: Color("Shadow1"), radius: 3, x: -5, y: -5)
//                                .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 5, y: 5)
                            HStack {
                                Text("#")
                                TextField("", text: $hexColor.code)
                            }
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(8)
                            .background(.back)
                            .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                            .shadow(color: Color("Shadow1"), radius: 3, x: -5, y: -5)
                            .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 5, y: 5)
                            
                            Button {
                                UIPasteboard.general.string = hexColor.code
                                print(hexColor.code)
                            } label: {
                                Image(systemName: Icon.copy.symbolName())
                                    .font(.title3)
                                    .padding(8)
                                    .background(.back)
                                    .cornerRadius(10, corners: [.topRight, .bottomRight])
                                    .shadow(color: Color("Shadow1"), radius: 3, x: -5, y: -5)
                                    .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 5, y: 5)
                            }
                        }
                        .frame(width: hueSize * 0.7)
                    }
                }
                .padding(.bottom, screenHeight * 0.04)
                
                // MARK: 色空間選択
                VStack {
                    // タブ
                    ColorPickerTabView()
                    
                    switch currentTab {
                    case .hsb:
                        HSBColorControl()
                    case .rgb:
                        RGBColorControl()
                    }
                }
                .frame(width: hueSize)
                
                Spacer()
                
                // MARK: プレビューカラー
                HStack(spacing: 0) {
                    ForEach(sampleColors.indices, id: \.self) { index in
                        Rectangle()
                            .frame(height: screenHeight * 0.1)
                            .offset(x: 0, y: currentColor == index ? -20 : 0)
                            .scaleEffect(currentColor == index ? 1.2 : 1.0)
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
                            
                            Image(systemName: Icon.plus.symbolName())
                                .font(.title2)
                        }
                    }
                }
//                .cornerRadius(10)
//                .shadow(color: Color("Shadow1"), radius: 1, x: -4, y: -4)
                .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 3, y: 3)
                .padding(.horizontal, screenWidth * 0.05)
                .padding(.bottom, screenWidth * 0.05)
            }
        }
    }
    
    // MARK: タブ
    @ViewBuilder
    func ColorPickerTabView() -> some View {
        HStack {
            ForEach(ColorPickerTab.allCases, id: \.hashValue) { tab in
                Text(tab.tabName())
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(currentTab == tab ? .back : .black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .background {
                        if currentTab == tab {
                            Capsule()
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        } else {
                            Capsule()
                                .stroke(.black)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            currentTab = tab
                        }
                    }
            }
        }
    }
    
    // MARK: HSB
    @ViewBuilder
    func HSBColorControl() -> some View {
        // MARK: 彩度
        VStack(spacing: 0) {
            HStack {
                Text("彩度")
                Spacer()
                Text(convertToPercentage(hsbColor.saturation))
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [
                        Color(hue: hsbColor.hue, saturation: 0.0, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.1, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.2, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.3, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.4, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.5, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.6, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.7, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.8, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 0.9, brightness: hsbColor.brightness),
                        Color(hue: hsbColor.hue, saturation: 1.0, brightness: hsbColor.brightness),
                    ]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: hueSize, height: 10)
                    .gesture(saturationDragGesture2)
                    .padding(.horizontal)
                
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: hsbColor.saturation * hueSize)
                .gesture(saturationDragGesture)
            }
        }
        
        // MARK: 明度
        VStack(spacing: 0) {
            HStack {
                Text("明度")
                Spacer()
                Text(convertToPercentage(hsbColor.brightness))
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.0),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.1),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.2),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.3),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.4),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.5),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.6),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.7),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.8),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 0.9),
                        Color(hue: hsbColor.hue, saturation: hsbColor.saturation, brightness: 1.0),
                    ]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: hueSize, height: 10)
                    .gesture(brightnessDragGesture2)
                    .padding(.horizontal)
                
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: hsbColor.brightness * hueSize)
                .gesture(brightnessDragGesture)
            }
        }
    }
    
    // MARK: RGB
    @ViewBuilder
    func RGBColorControl() -> some View {
        // MARK: 赤
        VStack(spacing: 0) {
            HStack {
                Text("R")
                Spacer()
                Text("\(Int(rgbColor.red * 255))")
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [
                        Color(red: 0.0, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.1, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.2, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.3, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.4, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.5, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.6, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.7, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.8, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 0.9, green: rgbColor.green, blue: rgbColor.blue),
                        Color(red: 1.0, green: rgbColor.green, blue: rgbColor.blue),
                    ]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: hueSize, height: 10)
                    .gesture(RedDragGesture2)
                    .padding(.horizontal)
                
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: rgbColor.red * hueSize)
                .gesture(RedDragGesture)
            }
        }
        
        // MARK: 緑
        VStack(spacing: 0) {
            HStack {
                Text("G")
                Spacer()
                Text("\(Int(rgbColor.green * 255))")
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [
                        Color(red: rgbColor.red, green: 0.0, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.1, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.2, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.3, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.4, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.5, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.6, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.7, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.8, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 0.9, blue: rgbColor.blue),
                        Color(red: rgbColor.red, green: 1.0, blue: rgbColor.blue),
                    ]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: hueSize, height: 10)
                    .gesture(GreenDragGesture2)
                    .padding(.horizontal)
                
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: rgbColor.green * hueSize)
                .gesture(GreenDragGesture)
            }
        }
        
        // MARK: 青
        VStack(spacing: 0) {
            HStack {
                Text("B")
                Spacer()
                Text("\(Int(rgbColor.blue * 255))")
            }
            
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: [
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.0),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.1),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.2),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.3),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.4),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.5),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.6),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.7),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.8),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 0.9),
                        Color(red: rgbColor.red, green: rgbColor.green, blue: 1.0),
                    ]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: hueSize, height: 10)
                    .gesture(BlueDragGesture2)
                    .padding(.horizontal)
                
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: rgbColor.blue * hueSize)
                .gesture(BlueDragGesture)
            }
        }
    }
    
    //MARK: ドラッグジェスチャー
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let translation = value.location
                let vector = CGVector(dx: translation.x - hueSize/2 + 20, dy: translation.y - hueSize/2 + 20)
                
                // -10 is circle radius since circle size is 20
                // for more info on circular slider
                // check the video link in description !!!
                
                // ラジアンを取得
                radians = atan2(vector.dy - 20, vector.dx - 20)
                
//                print(radians)
                
                //ラジアンから角度を求める
                angle = (radians * 180) / .pi
                
                if angle < 0 {
                    angle = 360 + angle
//                    print(angle)
                }
                
//                print(angle)
                
                hsbColor.hue = angle / 360
                
                if hsbColor.hue < 1  {
                    hsbColor.hue = 1 - hsbColor.hue
                }
                
                HSBToRGB(hsb: hsbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    //MARK: ドラッグジェスチャー
    var dragGesture2: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let translation = value.location
                let vector = CGVector(dx: translation.x, dy: translation.y)
                
                // ラジアンを取得
                radians = atan2(vector.dy - 20, vector.dx - 20)
                
                //ラジアンから角度を求める
                angle = (radians * 180) / .pi
                
                if angle < 0 {
                    angle = 360 + angle
                }
                
                hsbColor.hue = angle / 360
                
                if hsbColor.hue < 1  {
                    hsbColor.hue = 1 - hsbColor.hue
                }
                
                HSBToRGB(hsb: hsbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    
    //MARK: 彩度ドラッグジェスチャー
    var saturationDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x - 15) / hueSize
                hsbColor.saturation = min(max(0, ratio), 1)
                
                HSBToRGB(hsb: hsbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    var saturationDragGesture2: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x) / hueSize
                
                withAnimation {
                    hsbColor.saturation = min(max(0, ratio), 1)
                }
                
                HSBToRGB(hsb: hsbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    
    //MARK: 彩度ドラッグジェスチャー
    var brightnessDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x - 15) / hueSize
                hsbColor.brightness = min(max(0, ratio), 1)
                
                HSBToRGB(hsb: hsbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    var brightnessDragGesture2: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x) / hueSize
                
                withAnimation {
                    hsbColor.brightness = min(max(0, ratio), 1)
                }
                
                HSBToRGB(hsb: hsbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    
    //MARK: 赤ドラッグジェスチャー
    var RedDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x - 15) / hueSize
                rgbColor.red = min(max(0, ratio), 1)
                
                RGBToHSB(rgb: rgbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    var RedDragGesture2: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x) / hueSize
                
                withAnimation {
                    rgbColor.red = min(max(0, ratio), 1)
                }
                
                RGBToHSB(rgb: rgbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    //MARK: 緑ドラッグジェスチャー
    var GreenDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x - 15) / hueSize
                rgbColor.green = min(max(0, ratio), 1)
                
                RGBToHSB(rgb: rgbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    var GreenDragGesture2: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x) / hueSize
                
                withAnimation {
                    rgbColor.green = min(max(0, ratio), 1)
                }
                
                RGBToHSB(rgb: rgbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    //MARK: 青ドラッグジェスチャー
    var BlueDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x - 15) / hueSize
                rgbColor.blue = min(max(0, ratio), 1)
                
                RGBToHSB(rgb: rgbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    var BlueDragGesture2: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let ratio = (value.location.x) / hueSize
                
                withAnimation {
                    rgbColor.blue = min(max(0, ratio), 1)
                }
                
                RGBToHSB(rgb: rgbColor)
                RGBToHEX(rgb: rgbColor)
            }
    }
    
    // MARK: HSB から RGB に変換
    func HSBToRGB(hsb: HSBColor) {
        rgbColor = hsbColor.ToRGB(hsb: hsb)
    }
    
    // MARK: RGB から HSB に変換
    func RGBToHSB(rgb: RGBColor) {
        // HSBを取得
        hsbColor = rgbColor.ToHSB(rgbColor: rgb)
        // 色相を0~360の範囲にし、範囲の角度を反対にする
        var angleRad = (360 - (hsbColor.hue * 360)).truncatingRemainder(dividingBy: 360)
                
        // マイナスの場合は 360 足して調整
        if angleRad < 0 {
            angleRad += 360
        }
        
        // RGB、HEXは合っているが、HSBの色が違う
        // デバッグして「ToHSB」を試してみる
        
        // 角度からラジアンに変換
        radians = (angleRad * .pi) / 180
    }
    
    // MARK: RGB から HEX に変換
    func RGBToHEX(rgb: RGBColor) {
        hexColor = rgbColor.ToHEX(rgbColor: rgb)
    }
    
    // MARK: 数値から % に変換
    func convertToPercentage(_ value: Double) -> String {
        return String(format: "%.0f%%", value * 100)
    }
}

// MARK: RGB
struct RGBValueView: View {
    var colorLetter: String
    var colorValue: Int

    var body: some View {
        VStack(spacing: 8) {
//            Text(colorLetter)
//                .font(.title2)
//                .fontWeight(.bold)
            HStack {
                Text("\(colorValue)")
                    .font(.title3)
                    .fontWeight(.bold)
                Image(systemName: Icon.copy.symbolName())
            }
            .padding(8)
            .background(.copy)
            .cornerRadius(30)
            .shadow(color: Color("Shadow1"), radius: 3, x: -5, y: -5)
            .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 5, y: 5)
        }
    }
}

#Preview {
    ColorPickerView()
}
