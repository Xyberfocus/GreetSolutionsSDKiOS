//
//  SSIDHelper.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import Foundation
import UIKit
import NetworkExtension
import PromiseKit
import CoreLocation


public class SSIDHelper{
    
    public init() {}
    //    public static func aylin() -> String {
    //        return "Aylin te amo"
    //    }
    
    public static func startWifi() -> Bool {
        let defaults = UserDefaults.standard
        let userNumberSerial : String =  (UIDevice.current.identifierForVendor?.uuidString)!
        defaults.set(userNumberSerial, forKey: "gsId")
        var session : Int
        if defaults.integer(forKey: "sessionNumber") == 0 {
            defaults.set("no id", forKey: "userId")
            session = 1
            defaults.set(session, forKey: "sessionNumber")
            defaults.set(false, forKey: "UserRecognized")
            
            let hotspotConfig = NEHotspotConfiguration(ssid: "meshlium0534", passphrase: "xyber2020focus", isWEP: false)
            
            NEHotspotConfigurationManager.shared.apply(hotspotConfig){ (error) in
                if let error = error {
                    print("error = ",error)
                }
                else {
                    print("Success WIFI!")
                    
                }
            }
            defaults.set(false, forKey: "UserRegsiter")
            return true
            
        }else{
            let sessionNow = defaults.integer(forKey: "sessionNumber")
            session = sessionNow + 1
            print("Session number")
            print(session)
            defaults.set(session, forKey: "sessionNumber")
            return false
        }
    }
}
