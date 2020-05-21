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

    
   public let httpRequestUser = httpRequestHelper()
    public static func SendUniqueIdToLocalNetwork() -> Promise<NSDictionary>  {
      return Promise<NSDictionary> { seal in
        let UUIDUser : String =  (UserDefaults.standard.string(forKey: "gsId"))!
        let urlString : String = "/post_uuid.php"
        let stringPost : String = String(localServerIp) + urlString
        let requestHeader : [String:String] = [ "Content-Type" : "application/x-www-form-urlencoded"]
            var requestBodyComponents = URLComponents()
         requestBodyComponents.queryItems = [URLQueryItem(name: "uuid", value: UUIDUser)]
        var request = URLRequest(url: URL(string: stringPost)!)
            request.httpMethod = "POST"
            request.allHTTPHeaderFields = requestHeader
            request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        _ = URLSession.shared.dataTask(with: request){(datos,response,error) in
              if error != nil{
                print("Error POST")
                let errorPost = NSError(domain: " POST Failed Network", code: 100, userInfo: [NSLocalizedDescriptionKey: " POST Failed Network" ])
                seal.reject(errorPost)
              }else{
                if let content = datos {
                  do{
                    let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    seal.fulfill(jsonResult)
                  }catch{
                    let errorPostRequest = NSError(domain: " POST Failed Request", code: 101, userInfo: [NSLocalizedDescriptionKey: " POST Failed Request" ])
                    seal.reject(errorPostRequest)
                  }
                }
              }
            }.resume()
      }
    }
}




 
 
