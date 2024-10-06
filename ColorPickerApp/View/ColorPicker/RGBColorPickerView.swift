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
    
    // トースト
    @Binding var pickerToast: Toast?
    
    // 触覚フィードバック
    @State private var success: Bool = false
    
    var body: some View {
        VStack {
            // MARK: カラーストレージメニュー
            ColorStorageMenu(colorState: colorState, pickerToast: $pickerToast)
                .environmentObject(GlobalSettings())
            
            RGBSlider()
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
                TextField("", text: $colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(.back)
                    .cornerRadius(10)
                    .frame(width: shared.screenWidth * 0.2)
                    .multilineTextAlignment(.center)
                    .onChange(of: colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue) {
                        // 数字のみを許可
                        let filtered = colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue.filter { "0123456789".contains($0)
                        }
                        if filtered != colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue {
                            colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue = filtered
                        }
                        
                        // 最大桁数6桁を超えた場合、テキストを切り詰める
                        if 3 < colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue.count {
                            colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue = String(colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue.prefix(3))
                        }
                    }
                    .onSubmit {
                        // 確定
                        let redValue: Int = Int(colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue) 
                        ?? -1
                        
                        // 0~255の間であれば正常
                        if redValue < 256 && 0 <= redValue {
                            colorState.colorDatas[colorState.selectedIndex].rgb.red = Double(redValue)/255
                            // 保持用
                            colorState.colorDatas[colorState.selectedIndex].rgb.redCopy = colorState.colorDatas[colorState.selectedIndex].rgb.red
                            colorState.RGBToHSB()
                            colorState.RGBToHEX()
                            
                        } else {
                            colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue = Int(colorState.colorDatas[colorState.selectedIndex].rgb.redCopy*255).description
                        }
                    }
                
                // コピーボタン
                Button {
                    let redValue: String = colorState.colorDatas[colorState.selectedIndex].rgb.redByteScaleValue.description
                    UIPasteboard.general.string = redValue
                    
                    success.toggle()
                    pickerToast = Toast(style: .success, message: "「\(redValue)」をコピーしました。")
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
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.03)
                    .gesture(redBarDragGesture)
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
                .offset(x: colorState.colorDatas[colorState.selectedIndex].rgb.red * shared.hueBarSize)
                .animation(.spring, value: colorState.colorDatas[colorState.selectedIndex].rgb.red)
                .gesture(redThumbDragGesture)
            }
        }
        .padding(.bottom, shared.screenHeight * 0.02)
        .sensoryFeedback(.success, trigger: success)
        
        // MARK: Green
        VStack(spacing: 0) {
            HStack {
                Text("Green")
                    .fontWeight(.bold)
                Spacer()
                
                // Green値
                TextField("", text: $colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(.back)
                    .cornerRadius(10)
                    .frame(width: shared.screenWidth * 0.2)
                    .multilineTextAlignment(.center)
                    .onChange(of: colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue) {
                        // 数字のみを許可
                        let filtered = colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue.filter { "0123456789".contains($0)
                        }
                        if filtered != colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue {
                            colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue = filtered
                        }
                        
                        // 最大桁数6桁を超えた場合、テキストを切り詰める
                        if 3 < colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue.count {
                            colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue = String(colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue.prefix(3))
                        }
                    }
                    .onSubmit {
                        // 確定
                        let greenValue: Int = Int(colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue) 
                            ?? -1
                        // 0~255の間であれば正常
                        if greenValue < 256 && 0 <= greenValue {
                            colorState.colorDatas[colorState.selectedIndex].rgb.green =
                            Double(greenValue)/255
                            // 保持用
                            colorState.colorDatas[colorState.selectedIndex].rgb.greenCopy = colorState.colorDatas[colorState.selectedIndex].rgb.green
                            colorState.RGBToHSB()
                            colorState.RGBToHEX()
                            
                        } else {
                            colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue =
                                Int(colorState.colorDatas[colorState.selectedIndex].rgb.greenCopy*255).description
                        }
                    }
                
                // コピーボタン
                Button {
                    let greenValue: String = colorState.colorDatas[colorState.selectedIndex].rgb.greenByteScaleValue.description
                    UIPasteboard.general.string = greenValue
                    
                    success.toggle()
                    pickerToast = Toast(style: .success, message: "「\(greenValue)」をコピーしました。")
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
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.03)
                    .gesture(greenBarDragGesture)
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
                TextField("", text: $colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(8)
                    .background(.back)
                    .cornerRadius(10)
                    .frame(width: shared.screenWidth * 0.2)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onChange(of: colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue) {
                        // 数字のみを許可
                        let filtered = colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue.filter { "0123456789".contains($0)
                        }
                        if filtered != colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue {
                            colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue = filtered
                        }
                        
                        // 最大桁数6桁を超えた場合、テキストを切り詰める
                        if 3 < colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue.count {
                            colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue = String(colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue.prefix(3))
                        }
                    }
                    .onSubmit {
                        // 確定
                        let blueValue: Int = Int(colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue)
                            ?? -1
                        // 0~255の間であれば正常
                        if blueValue < 256 && 0 <= blueValue {
                            colorState.colorDatas[colorState.selectedIndex].rgb.blue =
                                Double(blueValue)/255
                            // 保持用
                            colorState.colorDatas[colorState.selectedIndex].rgb.blueCopy = colorState.colorDatas[colorState.selectedIndex].rgb.blue
                            colorState.RGBToHSB()
                            colorState.RGBToHEX()
                            
                        } else {
                            colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue =
                            Int(colorState.colorDatas[colorState.selectedIndex].rgb.blueCopy*255).description
                        }
                    }
                
                // コピーボタン
                Button {
                    let blueValue: String = colorState.colorDatas[colorState.selectedIndex].rgb.blueByteScaleValue.description
                    UIPasteboard.general.string = blueValue
                    
                    success.toggle()
                    pickerToast = Toast(style: .success, message: "「\(blueValue)」をコピーしました。")
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
                    .frame(width: shared.hueBarSize, height: shared.screenHeight * 0.03)
                    .gesture(blueBarDragGesture)
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
                .offset(x: colorState.colorDatas[colorState.selectedIndex].rgb.blue * shared.hueBarSize)
                .animation(.spring, value: colorState.colorDatas[colorState.selectedIndex].rgb.blue)
                .gesture(blueThumbDragGesture)
            }
        }
        .padding(.bottom, shared.screenHeight * 0.02)
    }
    
    //MARK: Red バードラッグジェスチャー
    var redThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, rgbProp: \.red, 
                              rgbByteValueProp: \.redByteScaleValue,
                              rgbCopyByteValueProp: \.redCopy)
    }

    var redBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, rgbProp: \.red, 
                              rgbByteValueProp: \.redByteScaleValue,
                              rgbCopyByteValueProp: \.redCopy)
    }

    //MARK: Green バードラッグジェスチャー
    var greenThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, rgbProp: \.green,
                              rgbByteValueProp: \.greenByteScaleValue,
                              rgbCopyByteValueProp: \.greenCopy)
    }

    var greenBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, rgbProp: \.green,
                              rgbByteValueProp: \.greenByteScaleValue,
                              rgbCopyByteValueProp: \.greenCopy)
    }
    
    //MARK: Blue バードラッグジェスチャー
    var blueThumbDragGesture: some Gesture {
        createColorBarGesture(offset: 15, rgbProp: \.blue,
                              rgbByteValueProp: \.blueByteScaleValue,
                              rgbCopyByteValueProp: \.blueCopy)
    }

    var blueBarDragGesture: some Gesture {
        createColorBarGesture(offset: 0, rgbProp: \.blue, 
                              rgbByteValueProp: \.blueByteScaleValue,
                              rgbCopyByteValueProp: \.blueCopy)
    }
    
    // MARK: ドラッグジェスチャー
    private func createColorBarGesture(offset: CGFloat, 
                                       rgbProp: WritableKeyPath<RGBColor, Double>,
                                       rgbByteValueProp: WritableKeyPath<RGBColor, String>,
                                       rgbCopyByteValueProp: WritableKeyPath<RGBColor, Double>) -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                let ratio = (value.location.x - offset) / shared.hueBarSize
                let adjustedRatio = min(max(0, ratio), 1)
                
                colorState.colorDatas[colorState.selectedIndex].rgb[keyPath: rgbProp] = adjustedRatio
                colorState.colorDatas[colorState.selectedIndex].rgb[keyPath: rgbByteValueProp] = Int(adjustedRatio * 255).description
                colorState.colorDatas[colorState.selectedIndex].rgb[keyPath: rgbCopyByteValueProp] = adjustedRatio
                
                
                colorState.RGBToHSB()
                colorState.RGBToHEX()
            }
    }
}

#Preview {
    @Previewable @State var isShowColorPickerView: Bool = true
    @Previewable @State var toast: Toast? = nil
    
    return VStack {
        ColorPickerView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.5)),
        ColorData(hsb: HSBColor(hue: 0.3, saturation: 0.5, brightness: 0.2)),
        ColorData(hsb: HSBColor(hue: 0.2, saturation: 0.5, brightness: 0.8)),
        ]), isShow: $isShowColorPickerView, toast: $toast)
        .environmentObject(GlobalSettings())
    }
}
