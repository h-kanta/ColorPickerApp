//
//  HEXColor.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/14.
//

import Foundation

struct HEXColor: Codable, Hashable {
    // hexコード
    var code: String
    
    init(code: String) {
        self.code = code
    }
        
    // MARK: HEX から RGB に変換
    func toRGB() -> RGBColor {
        // hexCode を Red, Green, Blue ごとに2文字ずつ切り取り
        var splitHexCode  = [String]()
        var startIndex = self.code.startIndex
        while startIndex < self.code.endIndex {
            let endIndex = self.code.index(startIndex, offsetBy: 2, limitedBy: self.code.endIndex) ?? self.code.endIndex
            let chunk = String(self.code[startIndex..<endIndex])
            splitHexCode.append(chunk)
            startIndex = endIndex
        }
        
        // 切り取った 16数 を 10進数 に変換
        // [red, green, blue]
        var rgb = [Double]()
        for code in splitHexCode {
            let scanner = Scanner(string: code)
            var result: UInt64 = 0
            if scanner.scanHexInt64(&result) {
                rgb.append(Double(result))
            }
        }
        
        return RGBColor(red: rgb[0]/255, green: rgb[1]/255, blue: rgb[2]/255)
    }
}
