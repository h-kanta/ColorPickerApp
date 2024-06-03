//
//  Header.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/21.
//

import SwiftUI

struct CustomNavigationBar: View {
    var headerTitle: String
    var leftImageSystemName: String?
    var rightImageSystemName: String?
    var dismiss: DismissAction?
    
    var body: some View {
        ZStack {
            HStack {
                // 左アイコン
                if let leftImageSystemName = leftImageSystemName {
                    Button {
                        // close の場合
                        if leftImageSystemName == Icon.close.symbolName(), let dismiss = dismiss {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: leftImageSystemName)
                            .font(.title)
                            .foregroundStyle(.black)
                    }
                } else {
                    Spacer()
                }
                
                // 右アイコン
                if let rightImageSystemName = rightImageSystemName {
                    Button {
   
                        
                    } label: {
                        Image(systemName: rightImageSystemName)
                            .font(.title)
                            .foregroundStyle(.black)
                    }
                } else {
                    Spacer()
                }
            }
            
            // ヘッダータイトル
            Text(headerTitle)
                .frame(maxWidth: .infinity)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding(.horizontal)
    }
}

#Preview {
    CustomNavigationBar(headerTitle: "配色一覧", leftImageSystemName: "arrow.left")
}
