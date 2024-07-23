//
//  RGBColorPickerView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/12.
//

import SwiftUI

struct RGBColorPickerView: View {
    
    @ObservedObject var colorState: ColorPickerViewState
    
    @EnvironmentObject private var shared: GlobalSettings
    
    // RGB値 0~255 テキストフィールド出力用に使用
    // Red
    @State private var redByteScaleValue: Int = 0
    // Green
    @State private var greenByteScaleValue: Int = 0
    // Blue
    @State private var blueByteScaleValue: Int = 0
    
    var body: some View {
        VStack {
            // MARK: プレビュー
            Rectangle()
                .frame(width: shared.hueBarSize * 0.3, height: shared.hueBarSize * 0.3)
                .foregroundStyle(Color(
                    hue: colorState.colorDatas[colorState.selectedIndex].hsb.hue,
                    saturation: colorState.colorDatas[colorState.selectedIndex].hsb.saturation,
                    brightness: colorState.colorDatas[colorState.selectedIndex].hsb.brightness))
                .cornerRadius(10)
                .shadow(color: Color("Shadow2").opacity(0.23), radius: 1, x: 4, y: 4)
                .padding(shared.hueBarSize * 0.03)
            
            RGBSlider()
        }
        .onAppear {
            RGBConvertToByteScale()
        }
    }
    
    // MARK: RGBカラーバー
    @ViewBuilder
    func RGBSlider() -> some View {
        // MARK: Red
        VStack(spacing: 0) {
            HStack {
                Text("Red")
                    .fontWeight(.bold)
                Spacer()
                
                // Red値
                TextField("", value: $redByteScaleValue, format: .number)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(.back)
                    .cornerRadius(10)
                    .frame(width: shared.screenWidth * 0.2)
                    .multilineTextAlignment(.center)
                    .onChange(of: redByteScaleValue) {
//                        if !colorState.isDragging {
//                            //redByteScaleValue = redByteScaleValue > 255 ? 255 : redByteScaleValue
//                            colorState.colorDatas[colorState.selectedIndex].rgb.red = Double(redByteScaleValue) / 255
//                        }
                    }
                // コピーボタン
                Button {
                    UIPasteboard.general.string = redByteScaleValue.description
                } label: {
                    Image(systemName: Icon.copy.symbolName())
                        .font(.title3)
                        .padding(8)
                        .background(.back)
                        .cornerRadius(10)
                }
            }
            
            // Red コントロール
            ZStack(alignment: .leading) {
                // バー
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: (0...10).map {
                        Color(red: Double($0) * 0.1,
                              green: colorState.colorDatas[colorState.selectedIndex].rgb.green,
                              blue: colorState.colorDatas[colorState.selectedIndex].rgb.blue)
                    }), startPoint: .leading, endPoint: .trailing))
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.02)
                    .gesture(redBarDragGesture)
                    .padding(.horizontal)
                
                // サム
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: colorState.colorDatas[colorState.selectedIndex].rgb.red * shared.hueBarSize)
                .animation(.spring, value: colorState.colorDatas[colorState.selectedIndex].rgb.red)
                .gesture(redThumbDragGesture)
            }
        }
        .padding(.bottom, shared.screenHeight * 0.02)
        
        // MARK: Green
        VStack(spacing: 0) {
            HStack {
                Text("Green")
                    .fontWeight(.bold)
                Spacer()
                
                // Green値
                TextField("", value: $greenByteScaleValue, format: .number)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(.back)
                    .cornerRadius(10)
                    .frame(width: shared.screenWidth * 0.2)
                    .multilineTextAlignment(.center)
                
                // コピーボタン
                Button {
                    UIPasteboard.general.string = greenByteScaleValue.description
                } label: {
                    Image(systemName: Icon.copy.symbolName())
                        .font(.title3)
                        .padding(8)
                        .background(.back)
                        .cornerRadius(10)
                }
            }
            
            // Green コントロール
            ZStack(alignment: .leading) {
                // バー
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: (0...10).map {
                        Color(red: colorState.colorDatas[colorState.selectedIndex].rgb.red,
                              green: Double($0) * 0.1,
                              blue: colorState.colorDatas[colorState.selectedIndex].rgb.blue)
                    }), startPoint: .leading, endPoint: .trailing))
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.02)
                    .gesture(greenBarDragGesture)
                    .padding(.horizontal)
                
                // サム
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: colorState.colorDatas[colorState.selectedIndex].rgb.green * shared.hueBarSize)
                .animation(.spring, value: colorState.colorDatas[colorState.selectedIndex].rgb.green)
                .gesture(greenThumbDragGesture)
            }
        }
        .padding(.bottom, shared.screenHeight * 0.02)
        
        // MARK: Blue
        VStack(spacing: 0) {
            HStack {
                Text("Blue")
                    .fontWeight(.bold)
                Spacer()
                
                // Blue値
                TextField("", value: $blueByteScaleValue, format: .number)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(.back)
                    .cornerRadius(10)
                    .frame(width: shared.screenWidth * 0.2)
                    .multilineTextAlignment(.center)
                
                // コピーボタン
                Button {
                    UIPasteboard.general.string = blueByteScaleValue.description
                    print(blueByteScaleValue)
                } label: {
                    Image(systemName: Icon.copy.symbolName())
                        .font(.title3)
                        .padding(8)
                        .background(.back)
                        .cornerRadius(10)
                }
            }
            
            // Blue コントロール
            ZStack(alignment: .leading) {
                // バー
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(gradient: Gradient(colors: (0...10).map {
                        Color(red: colorState.colorDatas[colorState.selectedIndex].rgb.red,
                              green: colorState.colorDatas[colorState.selectedIndex].rgb.green,
                              blue: Double($0) * 0.1)
                    }), startPoint: .leading, endPoint: .trailing))
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.02)
                    .gesture(blueBarDragGesture)
                    .padding(.horizontal)
                
                // サム
                ZStack {
                    Circle()
                        .foregroundStyle(.white)
                    
                    Circle()
                        .stroke(.black.opacity(0.3), lineWidth: 1)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .frame(width: 32, height: 32)
                .offset(x: colorState.colorDatas[colorState.selectedIndex].rgb.blue * shared.hueBarSize)
                .animation(.spring, value: colorState.colorDatas[colorState.selectedIndex].rgb.blue)
                .gesture(blueThumbDragGesture)
            }
        }
        .padding(.bottom, shared.screenHeight * 0.02)
    }
    
    //MARK: Red バードラッグジェスチャー
    var redThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, property: \.red)
    }

    var redBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, property: \.red)
    }

    //MARK: Green バードラッグジェスチャー
    var greenThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, property: \.green)
    }

    var greenBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, property: \.green)
    }
    
    //MARK: Blue バードラッグジェスチャー
    var blueThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, property: \.blue)
    }

    var blueBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, property: \.blue)
    }
    
    // MARK: ドラッグジェスチャー
    private func createColorBarGesture(offset: CGFloat, property: WritableKeyPath<RGBColor, Double>) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let ratio = (value.location.x - offset) / shared.hueBarSize
                let adjustedRatio = min(max(0, ratio), 1)
                
                colorState.colorDatas[colorState.selectedIndex].rgb[keyPath: property] = adjustedRatio
                
                colorState.RGBToHSB()
                colorState.RGBToHEX()
                RGBConvertToByteScale()
            }
    }
    
    // MARK: RGBの値の範囲を 「0.0~1.0」から「0~255」に変換
    func RGBConvertToByteScale() {
        redByteScaleValue = Int(colorState.colorDatas[colorState.selectedIndex].rgb.red * 255)
        greenByteScaleValue = Int(colorState.colorDatas[colorState.selectedIndex].rgb.green * 255)
        blueByteScaleValue = Int(colorState.colorDatas[colorState.selectedIndex].rgb.blue * 255)
    }
    
    // MARK: カラー変換
//    func ColorConvert() {
//        colorPickerState.RGBToHSB()
//        colorPickerState.RGBToHEX()
//        RGBConvertToByteScale()
//    }
}

#Preview {
    ColorPickerView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.5)),
        ColorData(hsb: HSBColor(hue: 0.3, saturation: 0.5, brightness: 0.2))
    ]))
        .environmentObject(GlobalSettings())
}
