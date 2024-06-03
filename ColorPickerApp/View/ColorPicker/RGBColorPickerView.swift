//
//  RGBColorPickerView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/12.
//

import SwiftUI

struct RGBColorPickerView: View {
    
    @ObservedObject var colorPickerState: ColorPickerViewState
    
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
                .foregroundStyle(Color(hue: colorPickerState.hsbColor.hue,
                                       saturation: colorPickerState.hsbColor.saturation,
                                       brightness: colorPickerState.hsbColor.brightness))
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
                        if !colorPickerState.isDragging {
                            //redByteScaleValue = redByteScaleValue > 255 ? 255 : redByteScaleValue
                            colorPickerState.rgbColor.red = Double(redByteScaleValue) / 255
                        }
                    }
                // コピーボタン
                Button {
                    UIPasteboard.general.string = redByteScaleValue.description
                    print(colorPickerState.rgbColor.red.description)
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
                              green: colorPickerState.rgbColor.green,
                              blue: colorPickerState.rgbColor.blue)
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
                .offset(x: colorPickerState.rgbColor.red * shared.hueBarSize)
                .animation(.spring, value: colorPickerState.rgbColor.red)
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
                    print(colorPickerState.rgbColor.green.description)
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
                        Color(red: colorPickerState.rgbColor.red,
                              green: Double($0) * 0.1,
                              blue: colorPickerState.rgbColor.blue)
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
                .offset(x: colorPickerState.rgbColor.green * shared.hueBarSize)
                .animation(.spring, value: colorPickerState.rgbColor.green)
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
                        Color(red: colorPickerState.rgbColor.red,
                              green: colorPickerState.rgbColor.green,
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
                .offset(x: colorPickerState.rgbColor.blue * shared.hueBarSize)
                .animation(.spring, value: colorPickerState.rgbColor.blue)
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
                
                colorPickerState.rgbColor[keyPath: property] = adjustedRatio
                
                colorPickerState.RGBToHSB()
                colorPickerState.RGBToHEX()
                RGBConvertToByteScale()
            }
    }
    
    // MARK: RGBの値の範囲を 「0.0~1.0」から「0~255」に変換
    func RGBConvertToByteScale() {
        redByteScaleValue = Int(colorPickerState.rgbColor.red * 255)
        greenByteScaleValue = Int(colorPickerState.rgbColor.green * 255)
        blueByteScaleValue = Int(colorPickerState.rgbColor.blue * 255)
    }
    
    // MARK: カラー変換
//    func ColorConvert() {
//        colorPickerState.RGBToHSB()
//        colorPickerState.RGBToHEX()
//        RGBConvertToByteScale()
//    }
}

#Preview {
//    @State var colorPickerState: ColorPickerViewState = .init()
    ColorPickerView(colorPickerState: .init())
        .environmentObject(GlobalSettings())
}
