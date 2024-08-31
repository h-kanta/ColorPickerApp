//
//  FavoriteColorView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/17.
//

import SwiftUI
import SwiftData

struct ColorStorageView: View {
    // SwiftData のデータを使用
    @Environment(\.modelContext) private var context
    // ColorStorage のデータを取得するために宣言
    @Query private var colorStorages: [ColorStorage]
    // カラー削除アラート表示
    @State private var isShowColorDeleteAlert: Bool = false
    // 削除するカラー
    @State private var colorDeleteTarget: ColorStorage?
    // グリッドカラム設定
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    // MARK: ナビゲーションバー
                    CustomNavigationBarContainer(
                        // 左
                        leftContent: {
                            Spacer()
                        },
                        // 中央
                        centerContent: {
                            Text("カラー")
                        },
                        // 右
                        rightContent: {
                            Button {
                                
                            } label: {
                                Image(systemName: Icon.sort.symbolName())
                            }
                        }
                    )
                    
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
            }
            .frame(maxHeight: .infinity)
            .padding(.bottom, 65)
        }
        // カラー削除アラート
        .alert("本当に削除しますか？", isPresented: $isShowColorDeleteAlert) {
            Button("キャンセル", role: .cancel) {
                isShowColorDeleteAlert = false
            }
            Button("削除", role: .destructive) {
                if let color = colorDeleteTarget {
                    context.delete(color)
                }
            }
        } message: {
            Text("削除したカラーを後から復元することはできません。")
        }
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
        
        // メニュー
        .contextMenu {
            // コピー
            Button {
                let code: String = color.rgbColor.toHEX().code
                UIPasteboard.general.string = code
                print(code)
            } label: {
                HStack {
                    Text("コピー")
                    Image(systemName: Icon.copy.symbolName())
                }
            }
            
            // 削除
            Button(role: .destructive) {
                colorDeleteTarget = color
                isShowColorDeleteAlert = true
            } label: {
                HStack {
                    Text("削除")
                        .foregroundStyle(.red)
                    Image(systemName: Icon.trash.symbolName())
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(GlobalSettings())
        .modelContainer(for: [ColorPalette.self, ColorStorage.self])
}
