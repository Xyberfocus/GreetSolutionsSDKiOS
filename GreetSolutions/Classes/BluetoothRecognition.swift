//
//  BluetoothRecognition.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import Foundation
import EstimoteProximitySDK
import CoreLocation

public class BluetoothRecognition{
    
    
    public init() {}
    
    public var proximityObserver: ProximityObserver!
    public var locationManager : CLLocationManager?
    
    
    public static func StartBluetooth()-> Bool {
        let router = SendToRouter()
        var response : Bool = false
        
        
        let estimoteCloudCredentials = CloudCredentials(appID: "xyberfocus-bluetooth-emf", appToken: "623ac796aed454de3d4b26c7672b225c")
        let proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("BLE Observer error: \(error)")
        })
        let rango = ProximityRange(desiredMeanTriggerDistance: 3.0)
        let zone = ProximityZone(tag: "holahola-f8u", range:rango!)
        zone.onEnter = { context in
            if UserDefaults.standard.bool(forKey: "UserRecognized"){
                print("El usuario ya fue reconocido no mando infomación")
                response =  false
            }else{
                UserDefaults.standard.set(true, forKey: "UserRecognized")
                if UserDefaults.standard.bool(forKey: "UserRegsiter"){
                    response = true
                }else{
                    print("No esta registrado todavía ")
                    response = false
                }
            }
        }
        proximityObserver.startObserving([zone])
        return response
    }
}
