//
//  HomeView.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/17.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
//                Color("BackColor")
//                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 10) {
                        Rectangle()
                            .frame(width: 200, height: 200)
                            .cornerRadius(10)
                            .shadow(color: Color("Shadow1"), radius: 3, x: -5, y: -5)
                            .shadow(color: Color("Shadow2").opacity(0.23), radius: 3, x: 5, y: 5)
                            .foregroundStyle(Color("BackColor"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
