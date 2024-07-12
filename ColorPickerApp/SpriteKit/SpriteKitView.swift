//
//  SpriteKitView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/06/13.
//

import SwiftUI
import SpriteKit

struct SpriteKitView: View {
    
    @EnvironmentObject private var shared: GlobalSettings
    
    // 色
    @State var sampleColors: [Color] = [.mint, .cyan, .pink, .yellow]
    // 選択中のプレビューカラー
    @State var currentColor: Int = 0
    
    let size: CGSize = CGSize(width: 200, height: 200)
    
    // SpriteKit の SKScene を用意
//    var scene: SKScene {
//        // SKScene オブジェクトを作成
//        let scene = ColorPalettePreviewScene(shared: shared, colors: $sampleColors)
//        // シーンが View の　frame サイズいっぱいに表示されるようにリサイズ
//        scene.scaleMode = .resizeFill
//        return scene
//    }
    
    var body: some View {
        ZStack {
//            Color(white: 0.8)
            
            // SpriteKit のシーンを 300×250 のサイズで描画
//            SpriteView(scene: scene, options: [.allowsTransparency])
//                .frame(width: .infinity, height: .infinity)
            
//            ColorPalettePreview(size: CGSize(width: shared.screenWidth,
//                                             height: shared.screenHeight),
//                                colors: $sampleColors)
            
            Text(sampleColors.count.description)
            
        }
    }
}

#Preview {
    SpriteKitView()
        .environmentObject(GlobalSettings())
}


// MARK: SKScene を継承したクラスを作成
class MySKScene: SKScene {
    
    // シーンが View に表示されたときに実行する処理
    override func didMove(to view: SKView) {
        // 背景色用
        let blue = UIColor(red: 0.29, green: 0.59, blue: 0.78, alpha: 1.0)
        // シーンの背景色を青にする
        self.backgroundColor = blue
        
        // シーンの中央を基準にノードが配置されるようにする
        // デフォルトではシーンの左下の原点が基準になっている
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // シェーダーの適用先となるノードを作成する
        let node = SKSpriteNode(
            // ノードを緑色にする
            // デフォルトでは透明
            color: UIColor(red: 0.64, green: 0.81, blue: 0.46, alpha: 1.0),
            // ノードサイズを 250 200 にする
            size: CGSize(width: 250, height: 200)
        )
        
        // fsh ファイルを指定してシェーダーを作成する
        // ファイル名の拡張子は省略できる
//        let shader = SKShader(fileNamed: "MyShader")
        
        // 作成したシェーダーをノードに適用する
//        node.shader = shader
        
        self.addChild(node)
    }
}
