//
//  ColorPreviewScene.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/06/16.
//

import SwiftUI
import SpriteKit
import SwiftData

class ColorPalettePreviewScene: SKScene {
        
    var shared: GlobalSettings
    @Binding var colorDatas: [ColorData]
    @Binding var isDrag: Bool
    @Binding var selectedColorIndex: Int
    @Binding var isBackground: Bool
    
    // カラーノード配列
    var colorNodes: [SKShapeNode] = []
    // カラーノードコピー用配列
    var workColorNodes: [SKShapeNode] = []
    
    // 背景用ノード
    var backgroundNode: SKSpriteNode
    
    // ドラッグされたカラープレビュー
    var dragedColorNode: SKShapeNode?
    // ドラッグされたカラープレビューの初期位置
    var dragedColorNodeInitPosition: CGPoint = CGPoint()
    
    // カラープレビュー追加ボタン用ノード
    var colorPreviewAddNode: SKShapeNode = .init()
    
    // 選択中のカラープレビューのマーキング用ノード
    var selectedColorNode: SKShapeNode = .init()
    
    // ゴミ箱
    var trashCircleNode: SKShapeNode = .init()
    var trashSymbolNode: SKSpriteNode = .init()
    
    // カラープレビューサイズ
    var rectWidth: CGFloat
    var rectHeight: CGFloat
    
    // 削除判定
    var isColorDelete: Bool = false
    var isAddColorStorage: Bool = false
    
    init(shared: GlobalSettings, colorDatas: Binding<[ColorData]>, isDrag: Binding<Bool>, selectedColorIndex: Binding<Int>, isBackground: Binding<Bool>) {
        _colorDatas = colorDatas
        _isDrag = isDrag
        _selectedColorIndex = selectedColorIndex
        _isBackground = isBackground
        
        // 共通
        self.shared = shared
        // カラープレビューサイズ
        self.rectWidth = shared.screenWidth / 6
        self.rectHeight = shared.screenWidth / 5
        // 背景用ノード
        backgroundNode = SKSpriteNode(color: .clear,
                                      size: CGSize(width: shared.screenWidth * UITraitCollection.current.displayScale,
                                                   height: shared.screenHeight * UITraitCollection.current.displayScale))
        
        super.init(size: CGSize(width: shared.screenWidth, height: shared.screenHeight))
        self.scaleMode = .fill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 初期表示処理
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // 長押しジェスチャーリコグナイザーの追加
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        view.addGestureRecognizer(longPressRecognizer)
        
        // 背景色クリア
        self.backgroundColor = .clear
        
        // 背景用ノード
        backgroundNode.position = CGPoint(x: 0, y: shared.screenHeight)
        backgroundNode.zPosition = -1  // 背景なので一番後ろに配置
        addChild(backgroundNode)
         
        // カラープレビューセットアップ
        setupColorPreviewNode()
        
        // ゴミ箱セットアップ
        setupTrashNode()
    }

    // カラープレビューセットアップ
    func setupColorPreviewNode() {
        // カラープレビュー全体の幅
        let rectFullWidth: CGFloat = rectWidth * CGFloat(colorDatas.count+1)
        // 画面幅とカラープレビュー全体の幅の差を求める
        let differenceSize: CGFloat = shared.screenWidth - rectFullWidth
        // その差の半分をカラープレビュー分、分割するし、スペースが均等になるようにする（スペースは6つ必要なため、カラープレビュー数 + 1 している。）
        let spaceSize: CGFloat = differenceSize / CGFloat(colorDatas.count+2)
        
        // カラープレビュー
        for (index, colorData) in colorDatas.enumerated() {
            //            let node = SKSpriteNode(color: UIColor(color), size: CGSize(width: rectWidth, height: rectHeight))
            //            node.position = CGPoint(x: rectWidth * CGFloat(index) + (rectWidth / 2) + (spaceSize * CGFloat(index+1)),
            //                                    y: (shared.screenHeight - shared.screenHeight/1.05) + (rectHeight/2))
            let colorNodePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight),
                                             cornerRadius: 5)
            let colorNode = SKShapeNode(path: colorNodePath.cgPath)
            colorNode.position = CGPoint(x: rectWidth * CGFloat(index) + (spaceSize * CGFloat(index+1)),
                                         y: (shared.screenHeight - shared.screenHeight/1.05))
            colorNode.fillColor = UIColor(Color(hue: colorData.hsb.hue, saturation: colorData.hsb.saturation, brightness: colorData.hsb.brightness))
            colorNode.name = "colorNode"
            colorNode.zPosition = 1
            
            addChild(colorNode)
            colorNodes.append(colorNode)
            
            // SKShapeNode がクラス型なため、 colorNode が参照型になっている。
            // そのため、同じ参照先から値を取得していることになる。
            // colorNodes を for で回して新しくインスタンスを作成するしかないかもしれない。
        }
        // 選択中カラープレビュー
        let selectedColorNodePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rectWidth*1.2, height: rectHeight*1.2),
                                                 cornerRadius: 10)
        
//        selectedColorNode = SKSpriteNode(color: UIColor(colors[selectedColorIndex].opacity(0.5)), size: CGSize(width: rectWidth*1.3, height: rectHeight*1.3))
//        selectedColorNode.position = colorNodes[selectedColorIndex].position
        selectedColorNode = SKShapeNode(path: selectedColorNodePath.cgPath)
        selectedColorNode.position = CGPoint(x: colorNodes[selectedColorIndex].position.x - (rectWidth*1.2-rectWidth)/2,
                                             y: colorNodes[selectedColorIndex].position.y - (rectHeight*1.2-rectHeight)/2)
        selectedColorNode.fillColor = UIColor(.black.opacity(0.2))
        selectedColorNode.zPosition = 0
        addChild(selectedColorNode)
        
        // カラープレビュー追加ボタン
        let colorPreviewAddNodePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight),
                                                        cornerRadius: 5)
        colorPreviewAddNode = SKShapeNode(path: colorPreviewAddNodePath.cgPath)
        colorPreviewAddNode.position = CGPoint(x: rectWidth * CGFloat(colorDatas.count) + (spaceSize * CGFloat(colorDatas.count+1)),
                                               y: (shared.screenHeight - shared.screenHeight/1.05))
        colorPreviewAddNode.fillColor = UIColor(.black.opacity(0.1))
        colorPreviewAddNode.name = "colorPreviewAddNode"
        addChild(colorPreviewAddNode)
                
        // UIImageをSKTextureに変換
        let texture = SKTexture(systemName: Icon.plus.symbolName(), pointSize: 32)
        // SKTextureを使ってSKSpriteNodeを作成
        let colorPreviewAddSymbolNode = SKSpriteNode(texture: texture)
        colorPreviewAddSymbolNode.position = CGPoint(x: rectWidth/2, y: rectHeight/2)  // 親ノードの中心に配置
        colorPreviewAddSymbolNode.size = CGSize(width: rectWidth / 2.5, height: rectWidth / 2.5)  // 円のサイズに合わせる
        colorPreviewAddSymbolNode.color = UIColor(.black)
        colorPreviewAddSymbolNode.colorBlendFactor = 1
        
        // シンボルノードをカラープレビュー追加ノードに追加
        colorPreviewAddNode.addChild(colorPreviewAddSymbolNode)
    }
    
    // ゴミ箱ノードセットアップ
    func setupTrashNode() {
        // 円形のノードを作成
        let trashCircleRadius: CGFloat = shared.screenHeight / 18
        trashCircleNode = SKShapeNode(circleOfRadius: trashCircleRadius)
        trashCircleNode.position = CGPoint(x: shared.screenWidth/2, y: shared.screenHeight - shared.screenHeight / 1.6)
        trashCircleNode.fillColor = UIColor(.white.opacity(0.8))  // 円の色を設定
        trashCircleNode.strokeColor = UIColor(.white.opacity(0.8))
        addChild(trashCircleNode)
        
        // UIImageをSKTextureに変換
        let texture = SKTexture(systemName: Icon.trash.symbolName(), pointSize: 32)
        
        // SKTextureを使ってSKSpriteNodeを作成
        trashSymbolNode = SKSpriteNode(texture: texture)
        trashSymbolNode.position = CGPoint(x: 0, y: 0)  // 親ノードの中心に配置
        trashSymbolNode.zRotation = .pi
        trashSymbolNode.size = CGSize(width: trashCircleRadius / 1.3, height: trashCircleRadius / 1.3)  // 円のサイズに合わせる
        trashSymbolNode.color = UIColor(.black)
        trashSymbolNode.colorBlendFactor = 1
            
        // シンボルノードを円形のノードに追加
        trashCircleNode.addChild(trashSymbolNode)
        // ドラッグ時のみ表示
        trashCircleNode.alpha = 0
    }
    
    // MARK: 更新
    override func update(_ currentTime: TimeInterval) {
        // バックグラウンド状態であれば処理を行わないように制御
        if !isBackground {
            // カラー変更をリアルタイムで反映
            colorNodes[selectedColorIndex].fillColor = UIColor(Color(hue: colorDatas[selectedColorIndex].hsb.hue,
                                                                     saturation: colorDatas[selectedColorIndex].hsb.saturation,
                                                                     brightness: colorDatas[selectedColorIndex].hsb.brightness))
            
            if colorDatas.count < 5 {
                colorPreviewAddNode.alpha = 1
            } else {
                colorPreviewAddNode.alpha = 0
            }
        }
    }
    
    // MARK: タッチジェスチャー
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // カラープレビュー
        if let node = atPoint(location) as? SKShapeNode, node.name == "colorNode" {
            // 選択したカラービューの index を取得
            for (index, colorNode) in colorNodes.enumerated() {
                if node == colorNode {
                    //  選択したカラープレビューの index を保持（カラーピッカー画面とバインドしているため）
                    selectedColorIndex = index
                    // 選択中のカラープレビューをマーク
                    let moveAction = SKAction.move(to: CGPoint(x: node.position.x - (rectWidth*1.2-rectWidth)/2,
                                                               y: node.position.y - (rectHeight*1.2-rectHeight)/2),
                                                   duration: 0.2)
                    let moveSequence = SKAction.sequence([moveAction])
                    selectedColorNode.run(moveSequence)
                }
            }

            node.zPosition = 10 // Bring to front
        }
        
        // カラープレビュー追加ボタン
        if let colorAddNode = atPoint(location) as? SKShapeNode, colorAddNode.name == "colorPreviewAddNode" {
            
            colorDatas.append(ColorData(hsb: HSBColor(hue: 0, saturation: 0, brightness: 0)))
            
            let colorNodePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: rectWidth, height: rectHeight),
                                        cornerRadius: 5)
            let colorNode = SKShapeNode(path: colorNodePath.cgPath)
            colorNode.fillColor = UIColor(Color(hue: colorDatas[colorDatas.count-1].hsb.hue,
                                                saturation: colorDatas[colorDatas.count-1].hsb.saturation,
                                                brightness: colorDatas[colorDatas.count-1].hsb.brightness))
            colorNode.name = "colorNode"
            colorNode.zPosition = 1
            
            addChild(colorNode)
            colorNodes.append(colorNode)
            
            
            let colorDatasCount = colorDatas.count < 5 ? colorDatas.count : colorDatas.count-1
            
            // カラープレビュー全体の幅
            let rectFullWidth: CGFloat = rectWidth * CGFloat(colorDatasCount+1)
            // 画面幅とカラープレビュー全体の幅の差を求める
            let differenceSize: CGFloat = shared.screenWidth - rectFullWidth
            // その差の半分をカラープレビュー分、分割するし、スペースが均等になるようにする（スペースは6つ必要なため、カラープレビュー数 + 1 している。）
            let spaceSize: CGFloat = differenceSize / CGFloat(colorDatasCount+2)
            // カラープレビュー再配置
            for (index, colorNode) in colorNodes.enumerated() {
                let colorNodeMoveAction = SKAction.move(to: CGPoint(x: rectWidth * CGFloat(index) + (spaceSize * CGFloat(index+1)),
                                                                    y: (shared.screenHeight - shared.screenHeight/1.05)),
                                                        duration: 0.2)
                let colorNodeMoveSequence = SKAction.sequence([colorNodeMoveAction])
                colorNode.run(colorNodeMoveSequence)
            }
            
            // カラープレビュー追加ボタン再配置
            let colorAddNodeMove = SKAction.move(to: CGPoint(x: rectWidth * CGFloat(colorDatasCount) + (spaceSize * CGFloat(colorDatasCount+1)),
                                                             y: (shared.screenHeight - shared.screenHeight/1.05)),
                                                 duration: 0.2)
            let colorAddNodeMoveSequence = SKAction.sequence([colorAddNodeMove])
            colorPreviewAddNode.run(colorAddNodeMoveSequence)
            
            // 選択中のカラープレビューをマーク
            let selectedColorMoveAction = SKAction.move(
                to: CGPoint(x: (rectWidth * CGFloat(colorDatasCount-1) + (spaceSize * CGFloat(colorDatasCount))) - (rectWidth*1.2-rectWidth)/2,
                            y: (shared.screenHeight - shared.screenHeight/1.05) - (rectWidth*1.2-rectWidth)/2),
                duration: 0.2)
            let selectedColorSequence = SKAction.sequence([selectedColorMoveAction])
            selectedColorNode.run(selectedColorSequence)
        }
    }
    
    // MARK: 長押しジェスチャー
    @objc func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            let location = recognizer.location(in: view)
            let convertedLocation = convertPoint(fromView: location)
            
            // タップされた位置にノードが存在するか確認
            if let node = atPoint(convertedLocation) as? SKShapeNode, node.name == "colorNode" {
                let scaleDown = SKAction.scale(to: 0.9, duration: 0.2) // 2倍に拡大
                let scaleUp = SKAction.scale(to: 1.2, duration: 0.2) // 元の半分に縮小
                let sequence = SKAction.sequence([scaleDown, scaleUp])
                node.run(sequence)
                
                dragedColorNode = node
                node.zPosition = 10
                // 位置を保存
                dragedColorNodeInitPosition = node.position
                
                // 背景色変更
                let backgroundAction = SKAction.colorize(with: UIColor(.black.opacity(0.6)), colorBlendFactor: 1.0, duration: 0.2)
                let backgroundSequence = SKAction.sequence([backgroundAction])
                backgroundNode.run(backgroundSequence)
                
                // ゴミ箱表示
                if colorNodes.count > 2 {
                    trashCircleNode.alpha = 1
                }
                
                // 選択中のカラープレビューマークを非表示
                selectedColorNode.alpha = 0
                
                // ドラッグフラグ
                isDrag = true
            }
            
        case .changed:
            if let node = dragedColorNode {
                let newLocation = recognizer.location(in: view)
                node.position = CGPoint(x: newLocation.x - node.frame.width/2, y: shared.screenHeight - (newLocation.y + node.frame.height/2))
                
                // カラー削除
                // カラープレビューは最低2つのため、2つ以下の場合は削除不可
                if colorNodes.count > 2 {
                    // 接触判定
                    if isCollisionBetweenCircleAndRect(circleCenterX: trashCircleNode.position.x,
                                                       circleCenterY: trashCircleNode.position.y,
                                                       radius: shared.screenHeight / 18,
                                                       rectCenterX: node.position.x + node.frame.width/2,
                                                       rectCenterY: node.position.y + node.frame.height/2,
                                                       width: node.frame.width,
                                                       height: node.frame.height) {
                        trashCircleNode.fillColor = UIColor(.red.opacity(0.8))
                        trashCircleNode.strokeColor = UIColor(.red.opacity(0.8))
                        trashSymbolNode.color = UIColor(.white)
                        
                        isColorDelete = true
                    } else {
                        trashCircleNode.fillColor = UIColor(.white.opacity(0.8))
                        trashCircleNode.strokeColor = UIColor(.white.opacity(0.8))
                        trashSymbolNode.color = UIColor(.black)
                        
                        isColorDelete = false
                    }
                }
                
//                let colorNodeMoveAction = SKAction.move(to: CGPoint(x: rectWidth * CGFloat(index) + (spaceSize * CGFloat(index+1)),
//                                                                    y: (shared.screenHeight - shared.screenHeight/1.05)),
//                                                        duration: 0.2)
//                let colorNodeMoveSequence = SKAction.sequence([colorNodeMoveAction])
//                colorNode.run(colorNodeMoveSequence)
                
//                print(copyColorNodes[0].position.x)
//                print(workColorNodes[1].position.x)
                
                // MARK: カラープレビュー並び替え
//                if workColorNodes[1].position.x < node.position.x {
//                    colorNodes[1].position.x = workColorNodes[0].position.x
//                }
            }
            
        case .ended:
            if let node = dragedColorNode {
                // 何かの判定が true の場合
                if isColorDelete || isAddColorStorage {
                    // 削除判定
                    if isColorDelete {
                        // カラー削除
                        for (index, colorNode) in colorNodes.enumerated() {
                            if node == colorNode {
                                colorDatas.remove(at: index)
                                colorNodes.remove(at: index)
                                node.removeFromParent()
                                
                                if selectedColorIndex == colorDatas.count {
                                    selectedColorIndex = colorDatas.count - 1
                                }
                            }
                        }
                        
                        // カラープレビュー再配置
                        // カラープレビュー全体の幅
                        let rectFullWidth: CGFloat = rectWidth * CGFloat(colorDatas.count+1)
                        // 画面幅とカラープレビュー全体の幅の差を求める
                        let differenceSize: CGFloat = shared.screenWidth - rectFullWidth
                        // その差の半分をカラープレビュー分、分割するし、スペースが均等になるようにする（スペースは6つ必要なため、カラープレビュー数 + 1 している。）
                        let spaceSize: CGFloat = differenceSize / CGFloat(colorDatas.count+2)
                        // カラー再配置
                        for (index, colorNode) in colorNodes.enumerated() {
                            let colorNodeMoveAction = SKAction.move(to: CGPoint(x: rectWidth * CGFloat(index) + (spaceSize * CGFloat(index+1)),
                                                                                y: (shared.screenHeight - shared.screenHeight/1.05)),
                                                                    duration: 0.2)
                            let colorNodeMoveSequence = SKAction.sequence([colorNodeMoveAction])
                            colorNode.run(colorNodeMoveSequence)
                        }
                        
                        // カラープレビュー追加ボタン再配置
                        let colorAddNodeMove = SKAction.move(to: CGPoint(x: rectWidth * CGFloat(colorDatas.count) + (spaceSize * CGFloat(colorDatas.count+1)),
                                                                         y: (shared.screenHeight - shared.screenHeight/1.05)),
                                                             duration: 0.2)
                        let colorAddNodeMoveSequence = SKAction.sequence([colorAddNodeMove])
                        colorPreviewAddNode.run(colorAddNodeMoveSequence)
                        
                        // 選択中のカラープレビューをマーク
                        let selectedColorMoveAction = SKAction.move(
                            //                        to: CGPoint(x: colorNodes[selectedColorIndex].position.x - (rectWidth*1.3-rectWidth)/2,
                            //                                    y: colorNodes[selectedColorIndex].position.y - (rectHeight*1.3-rectHeight)/2),
                            to: CGPoint(
                                x: (rectWidth * CGFloat(selectedColorIndex) + (spaceSize * CGFloat(selectedColorIndex+1))) - (rectWidth*1.2-rectWidth)/2,
                                y: (shared.screenHeight - shared.screenHeight/1.05) - (rectWidth*1.2-rectWidth)/2),
                            duration: 0.2)

                        let selectedColorSequence = SKAction.sequence([selectedColorMoveAction])
                        selectedColorNode.run(selectedColorSequence)
                        
                        trashCircleNode.fillColor = UIColor(.white.opacity(0.8))
                        trashCircleNode.strokeColor = UIColor(.white.opacity(0.8))
                        trashSymbolNode.color = UIColor(.black)
                        isColorDelete = false
                    }
                } else {
                    // 元の大きさに戻る
                    let scaleAction = SKAction.scale(to: 1.0, duration: 0.2)
                    let scaleSequence = SKAction.sequence([scaleAction])
                    node.run(scaleSequence)
                    
                    // 元の位置も戻る
                    let moveAction = SKAction.move(to: dragedColorNodeInitPosition, duration: 0.2)
                    let moveSequence = SKAction.sequence([moveAction])
                    node.run(moveSequence)
                    
                    dragedColorNode = nil
                    node.zPosition = 1
                }
                
                // 背景色クリア
                let backgroundAction = SKAction.colorize(with: .clear, colorBlendFactor: 1.0, duration: 0.2)
                let backgroundSequence = SKAction.sequence([backgroundAction])
                backgroundNode.run(backgroundSequence)
                
                // ゴミ箱非表示
                trashCircleNode.alpha = 0
                
                //  選択中のカラーノードを表示
                selectedColorNode.alpha = 1
                
                // ドラッグフラグ
                isDrag = false
            }
            
        default:
            if let node = dragedColorNode {
                let scaleAction = SKAction.scale(to: 1.0, duration: 0.2)
                let sequence = SKAction.sequence([scaleAction])
                node.run(sequence)
                
                dragedColorNode = nil
                node.zPosition = 0
                node.position = dragedColorNodeInitPosition
            }
        }
    }
    
    // MARK: 衝突判定
    func isCollisionBetweenCircleAndRect(circleCenterX cx: Double, circleCenterY cy: Double, radius: Double,
                                         rectCenterX rx: Double, rectCenterY ry: Double, width: Double, height: Double) -> Bool {
        // 矩形の各辺の最小値・最大値を計算
        let rectLeft = rx - width / 2
        let rectRight = rx + width / 2
        let rectTop = ry + height / 2
        let rectBottom = ry - height / 2

        // 円の中心から矩形の最近点までの x 座標と y 座標を求める
        let closestX = max(rectLeft, min(cx, rectRight))
        let closestY = max(rectBottom, min(cy, rectTop))

        // 最近点との距離を計算
        let distanceX = cx - closestX
        let distanceY = cy - closestY

        // 距離が円の半径以下なら衝突している
        return (distanceX * distanceX + distanceY * distanceY) <= (radius * radius)
    }
    
    func reorderColors() {
        // 位置に基づいてsampleColorsとcolorNodesを並び替える
        colorNodes.sort { $0.position.x > $1.position.x }
//        sampleColors = colorNodes.map { $0.color }
    }
    
    
    // タッチ
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        if let node = atPoint(location) as? SKSpriteNode, node.name == "colorNode" {
//            
//            selectedNode = node
//            
//            node.zPosition = 10 // Bring to front
//        }
//    }
    
    // MARK: ドラッグジェスチャー
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first, let node = selectedNode else { return }
//        
//        let location = touch.location(in: self)
//        
//        node.position = location
//    }
    
//    // MARK: ドロップ
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        if let node = selectedNode {
//            let scaleOriginal = SKAction.scale(to: 1.0, duration: 0.2)
//            let sequence = SKAction.sequence([scaleOriginal])
//            
//            node.run(sequence)
//            
//            node.zPosition = 0
//            selectedNode = nil
//            reorderColors()
//        }
//    }
}


