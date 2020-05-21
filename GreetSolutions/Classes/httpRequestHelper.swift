//
//  httpRequestHelper.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import UIKit
import PromiseKit

class httpRequestHelper {
  
  let servidorIP = "https://groovy-facet-268019.appspot.com"
  let localServerIp = "http://10.10.10.1"
  var jsonResult : NSDictionary = [:]
  
  
  func getRequest(urlStringGet :String)-> Promise<Any> {
    return Promise<Any> { seal in
      let stringGet : String = String(servidorIP) + urlStringGet
      let urlGet = URL(string: stringGet)
      _ = URLSession.shared.dataTask(with: urlGet!){(datos , response , error) in
        if let data = datos {
          do{
            let respuesta = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            seal.fulfill(respuesta)
          }catch{
            let errorGet = NSError(domain: "Json GET Failed", code: 100, userInfo: [NSLocalizedDescriptionKey: "Json GET Failed" ])
            seal.reject(errorGet)
          }
        }
        
      }.resume()
    }
  }
  
  
  func postRequest(urlStringPost : String , postParameters : Dictionary< String, String>) -> Promise<NSDictionary> {
    return Promise<NSDictionary> { seal in
      let stringPost : String = String(servidorIP) + urlStringPost
      let urlPost = URL(string: stringPost)
      var request = URLRequest(url: urlPost! as URL)
      request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.httpMethod = "POST"
      let serial = try! JSONSerialization.data(withJSONObject: postParameters, options: [])
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
  
  
  func localPostRequest(urlStringPost : String , postParameters : String) -> Promise<NSDictionary> {
    return Promise<NSDictionary> { seal in
      let stringPost : String = String(localServerIp) + urlStringPost
      let requestHeader : [String:String] = [ "Content-Type" : "application/x-www-form-urlencoded"]
      var requestBodyComponents = URLComponents()
      requestBodyComponents.queryItems = [URLQueryItem(name: "uuid", value: postParameters)]
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
  
  
  
  func getLocalRequest(urlStringGet :String)-> Promise<Any> {
    return Promise<Any> { seal in
      let stringGet : String = String(localServerIp) + urlStringGet
      let urlGet = URL(string: stringGet)
      _ = URLSession.shared.dataTask(with: urlGet!){(datos , response , error) in
        if let data = datos {
          do{
            let respuesta = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            seal.fulfill(respuesta)
            print( respuesta)
          }catch{
            let errorGet = NSError(domain: "Json GET Failed", code: 100, userInfo: [NSLocalizedDescriptionKey: "Json GET Failed" ])
            seal.reject(errorGet)
            print("error get")
          }
        }
        
      }.resume()
    }
  }
  
  
  
}








