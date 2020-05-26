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
        let rango = ProximityRange(desiredMeanTriggerDistance: 3.0)
        let zone = ProximityZone(tag: "holahola-f8u", range:rango!)
        zone.onEnter = { context in
//            if UserDefaults.standard.bool(forKey: "UserRecognized"){
//                print("El usuario ya fue reconocido no mando infomación")
//            }else{
//                UserDefaults.standard.set(true, forKey: "UserRecognized")
//                if UserDefaults.standard.bool(forKey: "UserRegsiter"){
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "greetSolutionsBluetooth"), object: nil)
//                }else{
//                    print("No esta registrado todavía ")
//
//                }
//            }
        }
        proximityObserver.startObserving([zone])
        
    }
}
