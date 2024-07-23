//
//  Sample.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/05/05.
//

import SwiftUI

import SwiftUI

import SwiftUI


final class DataSource: ObservableObject {
    @Published var counter = 0
    @Published var isDanger = false
}

struct Child: View {
    @State var sampleColors: [Color] = [.mint, .cyan, .pink, .yellow, .pink]
    @EnvironmentObject var shared: GlobalSettings
    
    @ObservedObject var dataSource: DataSource
    
    var body: some View {
        VStack {
            Button("increment ccounter") {
                dataSource.counter += 1
            }
            Text("count: \(dataSource.counter)")
        }
        .onAppear {
            print("Child が描画されたよ！！")
        }
    }
}

struct Sample: View {
    
    @StateObject var dataSource: DataSource = .init()
    
    var body: some View {
        VStack {
            Button("Change the Color") {
                dataSource.isDanger.toggle()
            }
            
            Text("sampleCount: \(dataSource.counter)")
            
            if dataSource.isDanger {
                Circle().foregroundStyle(.red)
            } else {
                Circle().foregroundStyle(.green)
            }
            
            Child(dataSource: dataSource)
        }
        .onAppear {
            print("Sample が描画されたよ！")
        }
    }
}

#Preview {
    Sample()
        .environmentObject(GlobalSettings())
}
