//
//  NotificationGreetSolution.swift
//  XyberfocusBluetooth
//
//  Created by Yoder Macas Galarza on 5/27/20.
//  Copyright © 2020 InnovGroup. All rights reserved.
//

import Foundation
import PromiseKit
import OneSignal

public class NotificationGreetSolution{
    
      public init() {}
        public static  func StartNotificationsGreetSolutions()  {
    
        //Función cuando recibo la notificación Push
        let notificationReceivedBlock: OSHandleNotificationReceivedBlock = { notification in
          
        }
        
        //Función cuando presiono la notificación Push
        let notificationOpenedBlock: OSHandleNotificationActionBlock = { result in
          NotificationCenter.default.post(name: Notification.Name(rawValue: "PushNotification"), object: nil)
          let payload: OSNotificationPayload = result!.notification.payload
          let additionalData = payload.additionalData
          if let installationid : String = (additionalData?["macRouter"]as? String)!{
            let macRouter = installationid
            UserDefaults.standard.setValue(macRouter, forKey: "MacRouter")
            print("MacRouter = \(macRouter)")
          }
        }
        
        
        //START OneSignal initialization code
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
        
        
       
        
        OneSignal.initWithLaunchOptions(onesignalInitSettings,
                                           appId: "1a43ef0e-2415-45e0-a6c9-33b852e3b69d",
                                           handleNotificationReceived: notificationReceivedBlock,
                                           handleNotificationAction: notificationOpenedBlock,
                                           settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        let UUIDUser : String =  (UserDefaults.standard.string(forKey: "gsId"))!
        OneSignal.sendTags(["user_id": UUIDUser])
        OneSignal.promptForPushNotifications(userResponse: { accepted in
          print("User accepted notifications: \(accepted)")
        })
        
        
        
    }
    
    
    
    
    
    
        public static func sendContactNotification(Response : String, MacRouter : String) -> Promise<NSDictionary>  {
        return Promise<NSDictionary> { seal in
            
            
            let servidorIP = "https://groovy-facet-268019.appspot.com"
            var jsonResult : NSDictionary = [:]
            let UUIDUser : String =  (UserDefaults.standard.string(forKey: "gsId"))!
            let urlAuthentification : String = "/MsgNotification/registerNotification/"
            let jsonReq = ["uuid":UUIDUser, "answer":Response,"macRouter":MacRouter] as Dictionary
            let stringPost : String = String(servidorIP) + urlAuthentification
            let urlPost = URL(string: stringPost)
            var request = URLRequest(url: urlPost! as URL)
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let serial = try! JSONSerialization.data(withJSONObject: jsonReq, options: [])
            request.httpBody = serial
            _ = URLSession.shared.dataTask(with: request ,completionHandler: { (datos , response , error) -> Void in
                if error != nil{
                    print("Error POST")
                    seal.reject(error!)
                }else{
                    if let content = datos {
                        do{
                            let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            seal.fulfill(jsonResult)
                        }catch{
                            let errorPost = NSError(domain: "Json POST Failed", code: 101, userInfo: [NSLocalizedDescriptionKey: "Json POST Failed" ])
                            print(errorPost)
                            seal.reject(errorPost)
                        }
                    }
                }
            }).resume()
        }
    }
    
}
