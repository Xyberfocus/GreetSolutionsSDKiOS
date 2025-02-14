//
//  SendToRouter.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import Foundation
import PromiseKit

public class SendToRouter {
    public init() {}
    public static func SendUniqueIdToLocalNetwork() -> Promise<String>  {
        return Promise<String> { seal in
            let UUIDUser : String =  (UserDefaults.standard.string(forKey: "gsId"))!
            let urlString : String = "/post_uuid.php"
            let localServerIp = "http://10.10.10.1"
            let stringPost : String = String(localServerIp) + urlString
            let requestHeader : [String:String] = [ "Content-Type" : "application/x-www-form-urlencoded"]
            var requestBodyComponents = URLComponents()
            requestBodyComponents.queryItems = [URLQueryItem(name: "uuid", value: UUIDUser)]
            var request = URLRequest(url: URL(string: stringPost)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = requestHeader
            request.httpBody = requestBodyComponents.query?.data(using: .utf8)
            URLSession.shared.dataTask(with: request){(datos,response,error) in
                if error != nil{
                    let errorPost = NSError(domain: "Error POST Router", code: 001)
                    print("Greet Solution Post Router error: \(errorPost)")
                    seal.reject(errorPost)
                }else{
                    let htmlContent : String = NSString(data: datos!, encoding: String.Encoding.utf8.rawValue)! as String
                    if htmlContent == "OK\n"{
                        let message = "Send Success to Router"
                        // Eliminamos la creación del NSDictionary y enviamos directamente el mensaje
                        seal.fulfill(message)
                        print("Greet Solution Post Router message: \(message)")
                    }else{
                        let errorPost = NSError(domain: "Error parameters POST Router", code: 002)
                        print("Greet Solution Post Router error: \(errorPost)")
                        seal.reject(errorPost)
                    }
                }
            }.resume()
        }
    }
}