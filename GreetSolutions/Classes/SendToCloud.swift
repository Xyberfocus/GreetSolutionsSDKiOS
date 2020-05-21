//
//  SendToCloud.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//
import Foundation
import PromiseKit

public class SendToCloud{
    
    public static func sendUniqueIdtoServer(userName : String , userPhone : String, userEmail : String) -> Promise<NSDictionary>  {
        return Promise<NSDictionary> { seal in
            let servidorIP = "https://groovy-facet-268019.appspot.com"
            var jsonResult : NSDictionary = [:]
            let UUIDUser : String =  (UserDefaults.standard.string(forKey: "gsId"))!
            let urlAuthentification : String = "/User/"
            let jsonReq = ["uuid":UUIDUser,"name":userName,"phone":userPhone,"email":userEmail] as Dictionary
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



