//
//  UINavigationController.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/08/14.
//

import SwiftUI

// UINavigationController を拡張して、デフォルトの動作をカスタマイズ
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    // viewDidLoad() メソッドは、ビューがロードされたときに呼び出されます。
    // このメソッドをオーバーライドして、インタラクティブポップジェスチャーのデリゲート (delegate) を self に設定しています。
    // これにより、ポップジェスチャーが開始されるかどうかの判断が、UINavigationController 自身のデリゲートメソッドで行われるようになります。
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
 
    // このメソッドは、ジェスチャーが開始される前に呼び出され、ジェスチャーが有効かどうかを判断します。
    // このコードでは、viewControllers.count > 1 という条件で、ナビゲーションスタックに複数のビューコントローラーがある場合のみジェスチャーが有効になるようにしています。
    // つまり、スタックに一つしかビューコントローラーがない場合は、スワイプで戻るジェスチャーが無効化されることになります。
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
