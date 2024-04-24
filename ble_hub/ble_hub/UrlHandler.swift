//
//  UrlHandler.swift
//  ble_hub
//
//  Created by Kevin Foong on 21/4/24.
//

import Foundation

enum ActionType: String {
    case TURN_ON = "turn_on"
    case TURN_OFF = "turn_off"
}

func handleUrlEvent(url: URL, bleManager: BleManager) {
    print("url: \(url)")
    
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
        print("Failed to create URL components");
        return
    }
    
    if let scheme = components.scheme {
        print("Scheme: \(scheme)");
    }
    
    if let host = components.host {
        print("Host: \(host)");
    }
    
    let path = components.path
    print("Path: \(path)");
    
    if let queryItems = components.queryItems {
        for queryItem in queryItems {
            print("\(queryItem.name): \(queryItem.value ?? "")")
        }
    }
    
    if (path == "action" && components.queryItems != nil) {
        let queryItems = components.queryItems;
        
        // device
        let device_num = queryItems!.first(where: {$0.name == "device"})
        // action
        let action = queryItems!.first(where: {$0.name == "action"})
        
        if (action != nil && action?.value != nil && device_num != nil && device_num?.value != nil) {
            let connectedDevices = bleManager.connectedDevices
            
            // convert device num str to int
            let device_number = Int(device_num!.value!)
            
            guard (device_number != nil) else {
                print("Device number could not be parsed into integer index position");
                return;
            }
            
            guard (connectedDevices.indices.contains(device_number!)) else {
                print("Device with index \(device_number!) not found. There are only \(connectedDevices.count) devices")
                return;
            }
            
            if (action!.value == ActionType.TURN_ON.rawValue) {
                bleManager.turnOnFlipper(peri: connectedDevices[device_number!])
            } else if (action!.value == ActionType.TURN_OFF.rawValue) {
                bleManager.turnOffFlipper(peri: connectedDevices[device_number!])
            }
        }
    }
}
 
