//
//  SendToCloud.swift
//  GreetSolutions
//
//  Created by Yoder Macas Galarza on 5/20/20.
//

import PromiseKit
import Foundation

class SendToCloud{
    let httpRequestUser = httpRequestHelper()
    func sendUniqueIdtoServer(userName : String , userPhone : String, userEmail : String) -> Promise<NSDictionary>  {
        return Promise<NSDictionary> { seal in
            let UUIDUser : String =  (UserDefaults.standard.string(forKey: "gsId"))!
            let urlAuthentification : String = "/User/"
            let jsonReq = ["uuid":UUIDUser,"name":userName,"phone":userPhone,"email":userEmail] as Dictionary
            httpRequestUser.postRequest(urlStringPost: urlAuthentification, postParameters: jsonReq).done{ stringResult  in
                seal.fulfill(stringResult)
            }.catch { error in
                let error = NSError(domain: "Setup Error Connection", code: 1,
                                    userInfo: [NSLocalizedDescriptionKey: "Setup Error Connection" ])
                seal.reject(error)
            }
        }
    }
}
