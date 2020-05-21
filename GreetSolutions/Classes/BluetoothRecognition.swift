//
//  BluetoothRecognition.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import Foundation
//import UserNotifications
import EstimoteProximitySDK

class BluetoothRecognition{
    func StartBluetooth() {
        //Bluetooth account
        let router = SendToRouter()
        let estimoteCloudCredentials = CloudCredentials(appID: "xyberfocus-bluetooth-emf", appToken: "623ac796aed454de3d4b26c7672b225c")
        //BLE Observer
        let proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("BLE Observer error: \(error)")
        })
        
        let rango = ProximityRange(desiredMeanTriggerDistance: 3.0)
        let zone = ProximityZone(tag: "holahola-f8u", range:rango!)
        zone.onEnter = { context in
            
            if UserDefaults.standard.bool(forKey: "UserRecognized"){
                print("El usuario ya fue reconocido no mando infomación")
                
            }else{
                UserDefaults.standard.set(true, forKey: "UserRecognized")
//                let content = UNMutableNotificationContent()
//                content.title = "Recongition"
//                content.body = "Your cellphone has been captured"
//                content.sound = UNNotificationSound.default
//                let request = UNNotificationRequest(identifier: "Enter", content: content, trigger: nil)
//                notificationCenter.add(request, withCompletionHandler: nil)
                
                if UserDefaults.standard.bool(forKey: "UserRegsiter"){
                    
                    router.SendUniqueIdToLocalNetwork().done{ result  in
                        _ = result
                        print(result)
                        
                        print("Se ha enviado la información al router")
                        UserDefaults.standard.set(true, forKey: "UserRecognized")
                    }.catch { error in
                        print("Se ha enviado la información al router")
                        UserDefaults.standard.set(true, forKey: "UserRecognized")
                        
                        print(error)
                    }
                    
                    
                }else{
                    
                    print("No esta registrado todavía ")
                }
                
                
            }
            
        }
        
        
        proximityObserver.startObserving([zone])
        
    }
    
    
}
