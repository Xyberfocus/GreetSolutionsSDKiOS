//
//  SSIDHelper.swift
//  GreetSolutionsSDK
//
//  Created by Yoder Macas Galarza on 5/20/20.
//  Modified for SDK integration on 3/04/25.
//

import Foundation
import UIKit
import NetworkExtension
import PromiseKit
import CoreLocation
import Network

/// A helper class to manage WiFi connections for Greet Solutions devices.
/// This class handles the discovery and connection to Greet Solutions networks.
public class SSIDHelper {
  /// Initialize a new SSIDHelper instance
  public init() {}
  
  private let gs = GreetSolutions.shared
  
  /// Error domain constant for Greet Solutions WiFi errors
  public static let errorDomain = "Greet Solutions Wifi Error"
  
  /// Notification name constants
  public struct Notifications {
    /// Posted when WiFi configuration succeeds
    public static let wifiConfigurationSuccess = Notification.Name(rawValue: "StartWifiConfigurateSuccess")
    /// Posted when WiFi configuration is not allowed for the user
    public static let wifiConfigurationNotAllowed = Notification.Name(rawValue: "WifiConfigurationNotAllow4User")
  }
  
  /// Start browsing for Greet Solutions devices
  /// - Note: Requires iOS 13.0 or later
  @available(iOS 13.0, *)
  public func startBrowsing() {
    let parameters = NWParameters()
    parameters.includePeerToPeer = true
    let browser = NWBrowser(for: .bonjour(type: "_greet._tcp", domain: nil), using: parameters)
    browser.stateUpdateHandler = { newState in
      switch newState {
      case .failed(let error):
        if error == NWError.dns(DNSServiceErrorType(kDNSServiceErr_DefunctConnection)) {
          let errorMessage = NSError(domain: SSIDHelper.errorDomain, code: 106)
          print(errorMessage)
          browser.cancel()
          self.startBrowsing()
        } else {
          let errorMessage = NSError(domain: SSIDHelper.errorDomain, code: 107)
          print(errorMessage)
          browser.cancel()
        }
      case .waiting(_):
        let errorMessage = NSError(domain: SSIDHelper.errorDomain, code: 105)
        print(errorMessage)
        break
      case .ready: break
      case .cancelled: break
      default: break
      }
    }
    browser.start(queue: .main)
  }
    
  /// Retrieves the router credentials from the Greet Solutions server
  /// - Returns: A Promise containing router credentials
  public func GetRouterCredentials() -> Promise<NSDictionary> {
    return Promise<NSDictionary> { seal in
      // Use the environment-specific URL from the GreetSolutions class
      let servidorIP = gs.getEnvironment().baseURL
      
      var jsonResult : NSDictionary = [:]
      let clientId = gs.CredencialsGS().GSCustomerId
      let urlAuthentification : String = "/client/getNetworkCredetials"
      let jsonReq = ["clientId" : clientId] as Dictionary
      let stringPost = gs.buildEndpoint(path: urlAuthentification)
      var componentes = URLComponents(string: stringPost)
      componentes?.queryItems = [
        URLQueryItem(name: "key", value: gs.CredencialsGS().GsCredencials)]
      var request = URLRequest(url: (componentes?.url!)!)
      request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
      request.httpMethod = "POST"
      let serial = try! JSONSerialization.data(withJSONObject: jsonReq, options: [])
      request.httpBody = serial
      _ = URLSession.shared.dataTask(with: request ,completionHandler: { (datos , response , error) -> Void in
        print(datos)
        print(response)
        print(error)
        if error != nil{
          let errorPost = NSError(domain: SSIDHelper.errorDomain, code: 101)
          seal.reject(errorPost)
        }else{
          if let content = datos {
            do{
              var routerGreet = ["id" : ""] as NSDictionary
              var SSID = ""
              var pass = ""
              var response = ["message" : ""] as NSDictionary
              let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
              if let result : String = jsonResult["clientId"]as? String{
                routerGreet = ["message" : result] as NSDictionary
              }
              if let result : String = jsonResult["ssid"]as? String{
                SSID = result
              }
              if let result : String = jsonResult["networkPass"]as? String{
                pass = result
              }
              if let result : String = jsonResult["respuesta"]as? String{
                response = ["message" : result] as NSDictionary
                
                let errorRouter = NSError(domain: SSIDHelper.errorDomain, code: 102)
                seal.reject(errorRouter)
              }
              print(SSID)
              print(pass)
              self.startWifi(SSID, pass)
              seal.fulfill(routerGreet)
            }catch{
              let errorPost = NSError(domain: SSIDHelper.errorDomain, code: 103)
              seal.reject(errorPost)
            }
          }
        }
      }).resume()
    }
  }
  
  /// Connects to a WiFi network with the provided SSID and password
  /// - Parameters:
  ///   - SSID: The network SSID
  ///   - pass: The network password
  public func startWifi(_ SSID : String, _ pass : String) {
    let hotspotConfig = NEHotspotConfiguration(ssid: SSID, passphrase: pass, isWEP: false)
    NEHotspotConfigurationManager.shared.apply(hotspotConfig){ error in
      print(error)
      if error != nil {
      
                  if error?.localizedDescription == "already associated."
        {
          print("Greet Solutions Wifi: OK 1/2")
          
          // Still notify success for "already associated" case
          UserDefaults.standard.set(true, forKey: "SSIDConfigurationSaved")
          NotificationCenter.default.post(name: Notifications.wifiConfigurationSuccess, object: nil)
        }
        else{
          NotificationCenter.default.post(name: Notifications.wifiConfigurationNotAllowed, object: nil)
          let errorMessage = NSError(domain: SSIDHelper.errorDomain, code: 104)
          print(errorMessage)
        }
      }
      else {
        print("Greet Solutions Wifi: Ok 2/2")
        UserDefaults.standard.set(true, forKey: "SSIDConfigurationSaved")
        NotificationCenter.default.post(name: Notifications.wifiConfigurationSuccess, object: nil)
      }
    }
  }
  
  /// Checks and reports the current network status
  public func greetNetworkStatus() {
    if UserDefaults.standard.bool(forKey: "SSIDConfigurationSaved"){
      NotificationCenter.default.post(name: Notifications.wifiConfigurationSuccess, object: nil)
    }else{
      NotificationCenter.default.post(name: Notifications.wifiConfigurationNotAllowed, object: nil)
    }
  }
  
  /// Starts the WiFi permission flow and connects to the network if needed
  /// - Parameter completion: Optional completion handler called when the process is complete
  public func startWifiPermissions(completion: ((Bool, Error?) -> Void)? = nil) {
    if #available(iOS 13.0, *) {
      startBrowsing()
    }
    
    // Check if user is already recognized/session is started
    let userId = UserDefaults.standard.string(forKey: "userId") ?? "no id"
    if userId == "no id" {
      // Start Greet session if needed
      gs.startGreet()
    }
    
    if !UserDefaults.standard.bool(forKey: "SSIDConfigurationSaved"){
        self.GetRouterCredentials().done{ result in
          completion?(true, nil)
        }.catch{ error in
          print(error)
          completion?(false, error)
        }
    } else {
      print("Greet Solutions Wifi: Network ok")
      NotificationCenter.default.post(name: Notifications.wifiConfigurationSuccess, object: nil)
      completion?(true, nil)
    }
  }
  
  /// Error codes used by SSIDHelper
  public enum ErrorCode: Int {
    /// Error getting router credentials from server
    case serverConnectionError = 101
    /// Invalid router response
    case routerResponseError = 102
    /// Error parsing server response
    case parsingError = 103
    /// WiFi configuration not allowed for user
    case wifiNotAllowedForUser = 104
    /// WiFi configuration not allowed for iOS 13 users
    case wifiNotAllowedForIOS13 = 105
    /// Connection error (recoverable)
    case connectionErrorRecoverable = 106
    /// Connection error (not recoverable)
    case connectionErrorNotRecoverable = 107
  }
  
  /**
   * Check if the network configuration exists and is valid
   * - Returns: Boolean indicating if the configuration is valid
   */
  public func isNetworkConfigured() -> Bool {
    return UserDefaults.standard.bool(forKey: "SSIDConfigurationSaved")
  }
  
  /**
   * Force a reconnection to the Greet Solutions network
   * - Parameter completion: Optional completion handler called when reconnection is complete
   */
  public func reconnectToNetwork(completion: ((Bool, Error?) -> Void)? = nil) {
    // Reset configuration flag to force reconnection
    UserDefaults.standard.set(false, forKey: "SSIDConfigurationSaved")
    // Start the connection process
    startWifiPermissions(completion: completion)
  }
}
