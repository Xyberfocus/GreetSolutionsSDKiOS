public static func sendUniqueIdtoServer(firstName : String , lastName : String ,userPhone : String, userEmail : String) -> Promise<NSDictionary>  {
        
        return Promise<NSDictionary> { seal in
            let userName : String = firstName + " " + lastName
            let servidorIP = "https://groovy-facet-268019.appspot.com"
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
            URLSession.shared.dataTask(with: request ,completionHandler: { (datos , response , error) -> Void in
                if error != nil{
                    let errorPost = NSError(domain: " Error POST Server", code: 003)
                    print("Greet Solution Post Server error: \(errorPost)")
                    seal.reject(errorPost)
                }else{
                    if let content = datos {
                        do{
                            let jsonResult = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                            if let _ = jsonResult["id"] as? String { // Cambiado resultado por _
                                let message = "Send Success to Server"
                                let respuesta = ["message" : message] as NSDictionary
                                seal.fulfill(respuesta)
                                print("Greet Solution Post Server message: \(message)")
                            }else{
                                let errorPost = NSError(domain: " User already exists", code: 004)
                                print("Greet Solution Post Server error: \(errorPost)")
                                seal.reject(errorPost)
                            }
                            // Eliminado el seal.fulfill(jsonResult) duplicado
                        }catch{
                            let errorPost = NSError(domain: " Error parameters POST Server", code: 005)
                            print("Greet Solution Post Server error: \(errorPost)")
                            seal.reject(errorPost)
                        }
                    }
                }
            }).resume()
        }
    }