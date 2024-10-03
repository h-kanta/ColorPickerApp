//
//  ColorPickerAppApp.swift
//  ColorPickerApp
//
//  Created by 堀川貫太 on 2024/04/10.
//

import SwiftUI
import SwiftData

@main
struct ColorPickerAppApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ColorPalette.self,
            ColorStorage.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
//    var paletteSharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            ColorPalette.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//    
//    var storageSharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            ColorStorage.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(GlobalSettings())
                .modelContainer(sharedModelContainer)
//                .modelContainer(paletteSharedModelContainer)
//                .modelContainer(storageSharedModelContainer)
        }
    }
}
