//
//  ble_hubApp.swift
//  ble_hub
//
//  Created by Kevin Foong on 15/4/24.
//

import SwiftUI

@main
struct ble_hubApp: App {
    @StateObject var bleController = BleManager()
//    @State var counter = 0;
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bleController)
                .handlesExternalEvents(preferring: ["*"], allowing: ["*"])
                .onOpenURL(perform: { url in
                    handleUrlEvent(url: url, bleManager: bleController)
                })
        }.commands {
            CommandGroup(replacing: .newItem, addition: { })
        }
        .handlesExternalEvents(matching: ["*"])
    }
}
