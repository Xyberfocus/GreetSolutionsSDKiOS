//
//  SendToRouter.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import Foundation
import PromiseKit

public class SendToRouter {
   public let httpRequestUser = httpRequestHelper()
    public func SendUniqueIdToLocalNetwork() -> Promise<NSDictionary>  {
      return Promise<NSDictionary> { seal in
        let UUIDUser : String =  (UserDefaults.standard.string(forKey: "gsId"))!
        let urlString : String = "/post_uuid.php"
        httpRequestUser.localPostRequest(urlStringPost: urlString, postParameters: UUIDUser).done{ result in
          print("Envie al router")
          seal.fulfill(result)
        }.catch { error in
          let error = NSError(domain: "I cant send data to router", code: 4,userInfo: [NSLocalizedDescriptionKey: "Send uuid Error Connection" ])
          seal.reject(error)
        }
      }
    }
}
