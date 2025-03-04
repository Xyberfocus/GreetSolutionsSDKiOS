//
//  GreetSolutions.swift
//  Pods
//
//  Created by Yoder Macas Galarza on 4/3/25.
//


import Foundation
import UIKit

public class GreetSolutions{
    
    public static let shared = GreetSolutions()
    /// Default initializer
    public init() {}
    
    // MARK: - Environment Configuration
       
       /// Enum to define available environments
       public enum Environment: String {
           case production = "production"
           case test = "test"
           case development = "development"
           
           /// The base URL for each environment
           public var baseURL: String {
               switch self {
               case .production:
                   return "https://admin-greetsolutions-gateway-prod-d2tbxc0g.uc.gateway.dev"
               case .test:
                   return "https://mobile-greetsolutions-gateway-test-b50pc74c.ue.gateway.dev"
               case .development:
                   return "https://mobile-greetsolutions-gateway-b50pc74c.uc.gateway.dev"
               }
           }
       }
       
       /// Current environment setting
       private var currentEnvironment: Environment
       
       /// Shared instance for easy access throughout the app
       public static let shared = GreetSolutions()
       
       /// Default initializer with production environment
       public init(environment: Environment = .production) {
           // Initialize with stored environment if available, otherwise use the parameter
           if let storedEnv = UserDefaults.standard.string(forKey: "GSEnvironment"),
              let env = Environment(rawValue: storedEnv) {
               self.currentEnvironment = env
           } else {
               self.currentEnvironment = environment
               // Save the initial environment
               UserDefaults.standard.set(environment.rawValue, forKey: "GSEnvironment")
               UserDefaults.standard.synchronize()
           }
       }
       
       /**
        Sets the environment for API calls
        
        - Parameter environment: The environment to use (production, test, or development)
        */
       public func setEnvironment(_ environment: Environment) {
           self.currentEnvironment = environment
           UserDefaults.standard.set(environment.rawValue, forKey: "GSEnvironment")
           UserDefaults.standard.synchronize()
       }
       
       /**
        Gets the current environment
        
        - Returns: The current environment setting
        */
       public func getEnvironment() -> Environment {
           return currentEnvironment
       }
    /**
     Stores GreetSolutions credentials to UserDefaults
     
     - Parameters:
        - credencials: API credentials string
        - customerId: Customer identifier string
     */
    public func GreetSolutionsCredencials(_ credencials: String, _ customerId: String) {
        UserDefaults.standard.set(credencials, forKey: "GSCredentials")
        UserDefaults.standard.set(customerId, forKey: "GSCustomerId")
        UserDefaults.standard.synchronize()
    }
    /**
      Retrieves stored GreetSolutions credentials
      
      - Returns: A tuple containing API credentials and customer ID
      */
     public func CredencialsGS() -> (GsCredencials: String, GSCustomerId: String) {
         let GsCredencials: String = UserDefaults.standard.string(forKey: "GSCredentials") ?? ""
         let GsCustomerId: String = UserDefaults.standard.string(forKey: "GSCustomerId") ?? ""
         return (GsCredencials, GsCustomerId)
     }
    
    /**
      Saves a photo to UserDefaults after compression and base64 encoding
      
      - Parameter photoGS: UIImage to be saved
      - Returns: A tuple containing success status and the base64 encoded string
      */
     public func SavePhoto(_ photoGS: UIImage) -> (Status: Bool, photoGreetB64: String) {
         let imageData = photoGS.jpegData(compressionQuality: 1)
         let imageBase64String = imageData?.base64EncodedString()
         guard let image = imageBase64String else {
             return (false, "MMM")
         }

         let imageNew = String(image.dropFirst())
         UserDefaults.standard.set(imageNew, forKey: "GreetSolutionsPhoto")
         UserDefaults.standard.synchronize()
         return (true, imageNew)
     }

    /**
      Retrieves the stored photo as a base64 encoded string
      
      - Returns: Base64 encoded string representation of the photo
      */
     public func getGreetPhoto() -> String {
         let photoBase64 = UserDefaults.standard.string(forKey: "GreetSolutionsPhoto")
         guard let photo = photoBase64 else {
             return "MMMMMM"
         }
         return photo
     }
    
    
    /**
         Initializes a new GreetSolutions session or increments the existing session counter
         Resets user recognition state for new sessions
         */
        public func startGreet() {
            var session: Int
            
            if UserDefaults.standard.integer(forKey: "sessionNumber") == 0 {
                UserDefaults.standard.set(false, forKey: "isUserRecognized")
                UIApplication.shared.applicationIconBadgeNumber = 0
                UserDefaults.standard.set("no id", forKey: "userId")
                session = 1
                UserDefaults.standard.set(session, forKey: "sessionNumber")
                print(session)
            } else {
                let sessionNow = UserDefaults.standard.integer(forKey: "sessionNumber")
                session = sessionNow + 1
                print("Session number")
                print(session)
                UserDefaults.standard.set(session, forKey: "sessionNumber")
            }
            print(session)
        }
        
        /**
         Saves user data to local storage
         
         - Parameters:
            - userId: User identifier string
            - deviceId: Device identifier string
         - Returns: Boolean indicating success of the operation
         */
        public func SaveUserLocaDB(_ userId: String, _ deviceId: String) -> Bool {
            UserDefaults.standard.set(userId, forKey: "userId")
            UserDefaults.standard.set(deviceId, forKey: "deviceId")
            UserDefaults.standard.synchronize()
            return true
        }
}
