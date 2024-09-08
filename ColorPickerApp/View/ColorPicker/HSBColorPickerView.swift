//
//  HSBColorPickerView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/12.
//

import SwiftUI

struct HSBColorPickerView: View {
    
    @ObservedObject var colorState: ColorPickerViewState

    @EnvironmentObject private var shared: GlobalSettings
    
    // 色相角度
    @State private var hueAngle: Double = 0
    
    @State private var isDragging: Bool = false
    
    // 触覚フィードバック
    @State private var success: Bool = false
    // トースト
    @Binding var pickerToast: Toast?
    
    
    var body: some View {
        VStack {
            // MARK: 色相
            ZStack {
                // バー
                Circle()
                    .stroke(
                        AngularGradient(gradient: Gradient(colors: [
                            Color(hue: 1.0,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.9,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.8,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.7,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.6,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.5,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.4,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.3,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.2,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.1,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                            Color(hue: 0.0,
                                  saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                  brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness),
                        ]), center: .center)
                        , lineWidth: 20)
                    .frame(width: shared.hueBarSize, height: shared.hueBarSize)
                    .shadow(color: Color("Shadow1"), radius: 5, x: 5, y: 5)
                    .shadow(color: Color("Shadow1"), radius: 5, x: -5, y: -5)
                    .gesture(hueBarDragGesture)
                
                // サム
                ForEach(Array(colorState.colorDatas.enumerated()), id: \.offset) { index, color in
                    ZStack {
                        Circle()
                            .frame(width: shared.hueBarSize * 0.2, height: shared.hueBarSize * 0.2)
                            .foregroundStyle(.white)
                            .overlay {
                                Circle()
                                    .stroke(Color(
                                            hue: color.hsb.hue,
                                            saturation: color.hsb.saturation,
                                            brightness: color.hsb.brightness),
                                            lineWidth: colorState.selectedIndex == index ? 13 : 2)
                                    .shadow(color: Color("Shadow2").opacity(0.2), radius: 3, x: -3, y: -3)
                                    .shadow(color: Color("Shadow2").opacity(0.2), radius: 3, x: 3, y: 3)
                                    .animation(.spring, value: colorState.selectedIndex)
                            }

                        Text(index == 0 ? "M" : index == 1 ? "A" : "B")
                    }
                    .zIndex(colorState.selectedIndex == index ? 1 : 0)
                    .offset(x: cos(color.hsb.hueRadian) * shared.hueBarSize/2,
                            y: sin(color.hsb.hueRadian) * shared.hueBarSize/2)
                    .animation(.spring, value: color.hsb.hue)
                    .gesture(hueThumbDragGesture(index: index))
                }
                    
                VStack(spacing: 8) {
                    // MARK: カラーストレージメニュー
                    ColorStorageMenu(colorState: colorState, pickerToast: $pickerToast)
                        .environmentObject(GlobalSettings())
                    
                    // MARK: HEX
                    HStack {
                        HStack {
                            Text("#").foregroundStyle(.gray)
                            TextField("", text: $colorState.colorDatas[colorState.selectedIndex].hex.code)
                                .onChange(of: colorState.colorDatas[colorState.selectedIndex].hex.code) {
                                    // 小文字のアルファベットと数字のみを許可
                                    let filtered = colorState.colorDatas[colorState.selectedIndex].hex.code.filter { "abcdef0123456789".contains($0)
                                    }
                                    if filtered != colorState.colorDatas[colorState.selectedIndex].hex.code {
                                        colorState.colorDatas[colorState.selectedIndex].hex.code = filtered
                                    }
                                    // 最大桁数6桁を超えた場合、テキストを切り詰める
                                    if colorState.colorDatas[colorState.selectedIndex].hex.code.count > 6 {
                                        colorState.colorDatas[colorState.selectedIndex].hex.code = String(colorState.colorDatas[colorState.selectedIndex].hex.code.prefix(6))
                                    }
                                }
                                .onSubmit {
                                    // 確定
                                    if colorState.colorDatas[colorState.selectedIndex].hex.code.count == 6 {
                                        colorState.HEXToRGB()
                                        colorState.RGBToHSB()
                                        colorState.colorDatas[colorState.selectedIndex].hex.copyCode = colorState.colorDatas[colorState.selectedIndex].hex.code
                                    } else {
                                        colorState.colorDatas[colorState.selectedIndex].hex.code = colorState.colorDatas[colorState.selectedIndex].hex.copyCode
                                    }
                                }
                                .kerning(2) // 文字の間隔を広げる
                                
                        }
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(8)
                        .background(.back)
                        .cornerRadius(10)
                        
                        // コピーボタン
                        Button {
                            UIPasteboard.general.string = colorState.colorDatas[colorState.selectedIndex].hex.code
                            
                            success.toggle()
                            pickerToast = Toast(style: .success, message: "コピーしました。")
                        } label: {
                            Image(systemName: Icon.copy.symbolName())
                                .font(.title3)
                                .padding(8)
                                .background(.back)
                                .cornerRadius(10)
                        }
                    }
                    .frame(width: shared.hueBarSize * 0.7)
                }
            }
            .padding(.bottom, shared.screenHeight * 0.04)
            
            HSBSlider()
        }
        .sensoryFeedback(.success, trigger: success)
    }
    
    // MARK: 彩度、明度スライダー
    @ViewBuilder
    func HSBSlider() -> some View {
        // 彩度スライダー
        VStack(spacing: 0) {
            HStack {
                Text("彩度")
                Spacer()
                // パーセント
                Text(colorState.convertToPercentage(
                    colorState.colorDatas[colorState.selectedIndex].hsb.saturation))
            }
            .fontWeight(.bold)
            
            // 彩度コントロール
            ZStack(alignment: .leading) {
                // バー
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: (0...10).map { 
                        Color(
                            hue: colorState.colorDatas[colorState.selectedIndex].hsb.hue,
                              saturation: Double($0) * 0.1,
                            brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness)
                    }), startPoint: .leading, endPoint: .trailing))
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.03)
                    .gesture(saturationBarDragGesture)
                    .padding(.horizontal, (shared.screenHeight * 0.05)/2)
                
                // サム
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: shared.screenHeight * 0.05, height: shared.screenHeight * 0.05)
                .offset(x: colorState.colorDatas[colorState.selectedIndex].hsb.saturation * shared.hueBarSize)
                .animation(.spring, value: colorState.colorDatas[colorState.selectedIndex].hsb.saturation)
                .gesture(saturationThumbDragGesture)
            }
        }
        .padding(.bottom, shared.screenHeight * 0.02)
        
        // MARK: 明度スライダー
        VStack(spacing: 0) {
            HStack {
                Text("明度")
                Spacer()
                // パーセント
                Text(colorState.convertToPercentage(
                    colorState.colorDatas[colorState.selectedIndex].hsb.brightness))
            }
            .fontWeight(.bold)
            
            // 明度コントロール
            ZStack(alignment: .leading) {
                // バー
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(
                                                colors: (0...10).map { Color(
                                                    hue: colorState.colorDatas[colorState.selectedIndex].hsb.hue,
                                                     saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                                                     brightness: Double($0) * 0.1)}),
                                         startPoint: .leading,
                                         endPoint: .trailing))
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.03)
                    .gesture(brightnessBarDragGesture)
                    .padding(.horizontal, (shared.screenHeight * 0.05)/2)
                
                // サム
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: shared.screenHeight * 0.05, height: shared.screenHeight * 0.05)
                .offset(
                    x: colorState.colorDatas[colorState.selectedIndex].hsb.brightness * shared.hueBarSize)
                .animation(.spring,
                           value: colorState.colorDatas[colorState.selectedIndex].hsb.brightness)
                .gesture(brightnessThumbDragGesture)
            }
        }
    }
    
    // MARK: 色相バードラッグジェスチャー
    // バー
    var hueBarDragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                let translation = value.location
                let vector = CGVector(dx: translation.x - shared.hueBarSize/2 + 20,
                                      dy: translation.y - shared.hueBarSize/2 + 20)
                
                // ラジアンを取得
                colorState.colorDatas[colorState.selectedIndex].hsb.hueRadian = atan2(vector.dy - 20, vector.dx - 20)

                //ラジアンから角度を求める
                hueAngle = (colorState.colorDatas[colorState.selectedIndex].hsb.hueRadian * 180) / .pi
                
                if hueAngle < 0 {
                    hueAngle = 360 + hueAngle
                }

                colorState.colorDatas[colorState.selectedIndex].hsb.hue = hueAngle / 360
                
                if colorState.colorDatas[colorState.selectedIndex].hsb.hue < 1  {
                    colorState.colorDatas[colorState.selectedIndex].hsb.hue = 1 - colorState.colorDatas[colorState.selectedIndex].hsb.hue
                }
                
                colorState.HSBToRGB()
                colorState.RGBToHEX()
            }
    }
    // サム
    func hueThumbDragGesture(index: Int) -> some Gesture {
        DragGesture(minimumDistance: 0)
            // ドラッグ時
            .onChanged { value in
                colorState.selectedIndex = index
                
                let translation = value.location
                let vector = CGVector(dx: translation.x, dy: translation.y)
                
                // ラジアンを取得
                colorState.colorDatas[colorState.selectedIndex].hsb.hueRadian = atan2(vector.dy - 20, vector.dx - 20)
                
                //ラジアンから角度を求める
                hueAngle = (colorState.colorDatas[colorState.selectedIndex].hsb.hueRadian * 180) / .pi
                
                if hueAngle < 0 {
                    hueAngle = 360 + hueAngle
                }
                
                colorState.colorDatas[colorState.selectedIndex].hsb.hue = hueAngle / 360
                
                if colorState.colorDatas[colorState.selectedIndex].hsb.hue < 1  {
                    colorState.colorDatas[colorState.selectedIndex].hsb.hue = 1 - colorState.colorDatas[colorState.selectedIndex].hsb.hue
                }
                
                colorState.HSBToRGB()
                colorState.RGBToHEX()
            }
    }
    
    //MARK: 彩度バードラッグジェスチャー
    var saturationThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, property: \.saturation)
    }

    var saturationBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, property: \.saturation)
    }

    //MARK: 明度バードラッグジェスチャー
    var brightnessThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, property: \.brightness)
    }

    var brightnessBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, property: \.brightness)
    }
    
    // MARK: ドラッグジェスチャー
    private func createColorBarGesture(offset: CGFloat, property: WritableKeyPath<HSBColor, Double>) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let ratio = (value.location.x - offset) / shared.hueBarSize
                let adjustedRatio = min(max(0, ratio), 1)
                
                colorState.colorDatas[colorState.selectedIndex].hsb[keyPath: property] = adjustedRatio
                
                colorState.HSBToRGB()
                colorState.RGBToHEX()
            }
    }
    
//    // MARK: RGBカラーサムドラッグジェスチャー
//    func RGBColorThumbDragGesture(rgb: ColorParameter) -> some Gesture {
//        DragGesture(minimumDistance: 0)
//            // ドラッグ時
//            .onChanged { value in
//                isDragging = true
//                
//                let ratio = (value.location.x - 16) / self.shared.hueBarSize
//                // 値を 0~1 に調整
//                let ratioNormalizedValue = min(max(0, ratio), 1)
//                
//                //
//                switch colorParameter {
//                case .saturation:
//                    self.hsbColor.saturation = ratioNormalizedValue
//                case .brightness:
//                    self.hsbColor.brightness = ratioNormalizedValue
//                case .red:
//                    self.rgbColor.red = ratioNormalizedValue
//                case .green:
//                    self.rgbColor.green = ratioNormalizedValue
//                case .blue:
//                    self.rgbColor.blue = ratioNormalizedValue
//                }
//                
//                self.HSBToRGB()
//                self.RGBToHEX()
//            }
//        
//            // ドラッグ終了時
//            .onEnded { _ in
//                self.isDragging = false
//            }
//    }
    
//    // MARK: RGBカラーバードラッグジェスチャー
//    func RGBColorBarDragGesture(colorParameter: ColorParameter) -> some Gesture {
//        DragGesture(minimumDistance: 0)
//            // ドラッグ時
//            .onChanged { value in
//                self.isDragging = true
//                
//                let ratio = (value.location.x) / self.shared.hueBarSize
//                // 値を 0~1 に調整
//                let ratioNormalizedValue = min(max(0, ratio), 1)
//                
//                //
//                switch colorParameter {
//                case .saturation:
//                    self.hsbColor.saturation = ratioNormalizedValue
//                case .brightness:
//                    self.hsbColor.brightness = ratioNormalizedValue
//                case .red:
//                    self.rgbColor.red = ratioNormalizedValue
//                case .green:
//                    self.rgbColor.green = ratioNormalizedValue
//                case .blue:
//                    self.rgbColor.blue = ratioNormalizedValue
//                }
//                
//                self.HSBToRGB()
//                self.RGBToHEX()
//            }
//        
//            // ドラッグ終了時
//            .onEnded { _ in
//                self.isDragging = false
//            }
//    }
//
//    // MARK: カラー変換
//    func ColorConvert() {
//        colorState.HSBToRGB()
//        colorState.RGBToHEX()
//    }
}

#Preview {
    @State var isShowColorPickerView: Bool = true
    @State var toast: Toast? = nil
    
    return VStack {
        ColorPickerView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.5)),
        ColorData(hsb: HSBColor(hue: 0.3, saturation: 0.5, brightness: 0.2)),
        ColorData(hsb: HSBColor(hue: 0.2, saturation: 0.5, brightness: 0.8)),
        ]), isShow: $isShowColorPickerView, toast: $toast)
        .environmentObject(GlobalSettings())
    }
}
