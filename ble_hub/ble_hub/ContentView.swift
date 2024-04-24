//
//  ContentView.swift
//  ble_hub
//
//  Created by Kevin Foong on 15/4/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var bleController: BleManager;
    
    var body: some View {
        ZStack {
            Color("ThemeColor")
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            VStack{
                Text("BLE Peripheral Searcher")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center).padding()
                Button("Start scanning") {
                    bleController.connectToDevices()
                }
                .foregroundColor(.white).padding()
                List(bleController.connectedDevices, id: \.peri.name) {a in
                    Text(a.peri.name!)
                    Button("Turn on flipper") {
                        bleController.turnOnFlipper(peri: a)
                    }
                    Button("Turn off flipper") {
                        bleController.turnOffFlipper(peri: a)
                    }
                }
            }
        }
    }
}
