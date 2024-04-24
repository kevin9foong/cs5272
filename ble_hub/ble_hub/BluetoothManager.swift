//
//  BluetoothManager.swift
//  ble_hub
//
//  Created by Kevin Foong on 15/4/24.
//

import Foundation
import CoreBluetooth

struct Peripheral {
    let peri: CBPeripheral
    let charac: CBCharacteristic?
}

class BleManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
//    @Published var isBleManagerSwitchedOn = false
    @Published var connectedDevices: [Peripheral] = []
    var preConnectedDevices: [CBPeripheral] = []
    
    var centralManager: CBCentralManager!
    
    // known service and char UUIDs
    let flipperServiceUUID = CBUUID(string: "7ba0d744-2692-45f6-b875-ebd7f5e0aab7")
    let flipperCharacteristicUUID = CBUUID(string: "01f9d212-8a5b-4cec-bba7-a0034901d34b")
    
    override init() {
        super.init()
        // create new instance of CBCentralManager - find and connect to Peripherals
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            isBleManagerSwitchedOn = true
//            connectToDevices()
//        } else {
//            isBleManagerSwitchedOn = false
//        }
    }
    
    func connectToDevices() {
        centralManager.scanForPeripherals(withServices: [flipperServiceUUID], options: nil)
        //        centralManager.scanForPeripherals(withServices: nil, options: nil) scans for all?
        print("Scanning!")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        guard peripheral.name != nil else {return}
        
        print("Device found with name: " + peripheral.name!)
//        centralManager.stopScan()  seems to only find one for now, remove
//        print("Stop scanning")
        preConnectedDevices.append(peripheral);
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to device: " + peripheral.name!)
        peripheral.discoverServices([flipperServiceUUID]) // discover known service UUID
        peripheral.delegate = self
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        print("Discovered services for peripheral with name: " + peripheral.name!)
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics([flipperCharacteristicUUID], for: service)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        print("Discovered characteristic for peripheral with name: " + peripheral.name!)
        if let charac = service.characteristics {
            for characteristic in charac {
                if characteristic.uuid == flipperCharacteristicUUID {
                    connectedDevices.append(Peripheral(peri: peripheral, charac: characteristic))
                    print("Adding connected flipper device with name: " + peripheral.name!)
                }
            }
        }
    }
    
    func turnOnFlipper(peri: Peripheral) {
        print("Turning on flipper: " + peri.peri.name!)
        sendDataToCharacteristic(peri: peri, data: Data([0]))
    }
    
    func turnOffFlipper(peri: Peripheral) {
        print("Turning off flipper: " + peri.peri.name!)
        sendDataToCharacteristic(peri: peri, data: Data([1]))
    }
    
    func sendDataToCharacteristic(peri: Peripheral, data: Data) {
        peri.peri.writeValue(data, for: peri.charac!, type: .withResponse)
    }
}
