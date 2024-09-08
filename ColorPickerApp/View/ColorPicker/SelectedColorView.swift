//
//  SelectedColorView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/08/31.
//

import SwiftUI
import SwiftData

struct SelectedColorView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var colorStorages: [ColorStorage]
    
    // カラーデータ
    @ObservedObject var colorState: ColorPickerViewState
    
    @State private var selectedColor: ColorStorage?
    
    // グリッドカラム設定
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    @State private var success: Bool = false
    
    var body: some View {
        VStack {
            // MARK: ナビゲーションバー
            CustomNavigationBarContainer(
                // 左
                leftContent: {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: Icon.close.symbolName())
                    }
                },
                // 中央
                centerContent: {
                    Text("カラー選択")
                },
                // 右
                rightContent: {
                    if let _ = selectedColor {
                        Button {
                            if let color = selectedColor {
                                colorState.colorDatas[colorState.selectedIndex].rgb = color.rgbColor
                                colorState.RGBToHSB()
                                colorState.RGBToHEX()
                                
                                success.toggle()
                                dismiss()
                            }
                        } label: {
                            Text("選択")
                        }
                    } else {
                        Button {
                            // 何もしない
                        } label: {
                            Text("選択")
                                .foregroundStyle(.black.opacity(0.2))
                        }
                    }
                }
            )
            .padding(.top)
            
            Spacer()
            
            // カラーグリッド
            GeometryReader { geometry in
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(colorStorages, id: \.self) { color in
                            colorGridItem(color: color, geometry: geometry)
                        }
                    }
                    .padding()
                }
            }
        }
        .sensoryFeedback(.success, trigger: success)
    }
    
    //
    func colorGridItem(color: ColorStorage, geometry: GeometryProxy) -> some View {
        VStack(spacing: 8) {
            // カラー
            Circle()
                .frame(width: (geometry.size.width - 60) / 5,
                       height: (geometry.size.width - 60) / 5) // 60は各アイテムの間隔を考慮
                .foregroundStyle(Color(red: color.rgbColor.red,
                                       green: color.rgbColor.green,
                                       blue: color.rgbColor.blue))
                .cornerRadius(10, corners: .allCorners)
                .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 3, y: 3)
            
            // HEXコード
            Text("# \(color.rgbColor.toHEX().code)")
                .font(.caption)
     
        }
        .padding(8)
        .background {
            if let selectedColor = selectedColor, selectedColor == color {
                Rectangle()
                    .stroke(lineWidth: 1)
            }
        }
        .onTapGesture {
            selectedColor = color
        }
    }
}

#Preview {
    SelectedColorView(colorState: ColorPickerViewState(colorDatas: [
        ColorData(hsb: HSBColor(hue: 0.5, saturation: 0.5, brightness: 0.5)),
        ColorData(hsb: HSBColor(hue: 0.3, saturation: 0.5, brightness: 0.2)),
        ColorData(hsb: HSBColor(hue: 0.2, saturation: 0.5, brightness: 0.8)),
    ]))
}