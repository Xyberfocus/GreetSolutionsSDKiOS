//
//  BluetoothRecognition.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import Foundation
import EstimoteProximitySDK


public class BluetoothRecognition{
    
    public init() {}
    public static var proximityObserver: ProximityObserver!
    // debe recibir la referencia que le llama
    //inyección de dependencias
    // delegtes
    public static func StartBluetooth(){
        let estimoteCloudCredentials = CloudCredentials(appID: "xyberfocus-bluetooth-emf", appToken: "623ac796aed454de3d4b26c7672b225c")
        //BLE Observer
        proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("BLE Observer error: \(error)")
        })
        let zone = ProximityZone(tag: "holahola-f8u", range:ProximityRange.far)
        
        zone.onEnter = { result in
             
             print("Greet Solution Bluetooth on Enter Zone: Success")
            // NotificationCenter.default.post(name: Notification.Name(rawValue: "greetSolutionsBluetooth"), object: nil)
         }
        zone.onContextChange = { result in
            
            var session : Int
            let sessionNow = UserDefaults.standard.integer(forKey: "BluetoothOnContextChange")
            session = sessionNow + 1
            UserDefaults.standard.set(session, forKey: "BluetoothOnContextChange")
            print("Greet Solution Bluetooth onContext Zone times \(session)")
            NotificationCenter.default.post(name: Notification.Name(rawValue: "greetSolutionsBluetooth"), object: nil)
        }
        
        zone.onExit = { result in
            print("Greet Solution Bluetooth on Exit Zone: Success")
           // NotificationCenter.default.post(name: Notification.Name(rawValue: "greetSolutionsBluetooth"), object: nil)
            
        }
        
        proximityObserver.startObserving([zone])
        
    }
}
