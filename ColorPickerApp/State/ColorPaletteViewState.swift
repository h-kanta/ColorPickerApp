//
//  ColorPaletteViewState.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/08/23.
//

import Foundation

class ColorPaletteViewState: ObservableObject {
    @Published var selectedSort: Bool
    
    init(selectedSort: Bool) {
        self.selectedSort = selectedSort
    }
}
