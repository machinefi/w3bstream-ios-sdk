import Foundation

public extension W3bStream {
    
    
    /// make the https upload payload
    /// - Parameters:
    ///   - info: json string
    /// - Returns: description
    static func makePayload(info: String) -> [String: Any]? {

        guard let IMEI = KeychainWrapper.standard.string(forKey: imei_key) else {
            print("IMEI is forced need")
            return nil
        }
        guard let jsonData = info.data(using: .utf8) else {
            return nil
        }

        let hash = jsonData.sha256()
        guard let key = MFKeychainHelper.loadKey(name: MFKeychainHelper.PrivateKeyName) else {
            print("load key failed")
            return nil
        }
        guard let signature = MFKeychainHelper.makeSignatureWithABIEncoding(key, hash: hash) else {
                return nil
        }
        guard let pubKey = MFKeychainHelper.getPubKey(key) else {
            return [:]
        }
        let compressPubKey = MFKeychainHelper.compressedPubKey(pubKey)

        
        return ["data": info,
                "imei": IMEI,
                "pubKey": "\(compressPubKey)",
                "signature": "\(signature.toHexString().addHexPrefix())"
               ]
        
    }
    
    /// make the websocket upload payload
    /// - Parameters:
    ///   - info: json string
    /// - Returns: description
    static func makeWebsocketPayload(_ info: String) -> [String:Any]? {
       guard let payload = makePayload(info: info) else {
           return nil
       }
        let dic = ["id": 28,
                   "jsonrpc": "2.0",
                   "method": "mutation",
                   "params": [
                        "input": payload,
                        "path": "data"
                    ]
        ] as [String : Any]
        return dic
    }
    
    
    /// upload the data using https. the independent method
    /// - Parameters:
    ///   - url: url
    ///   - payload: generated by makePayload
    ///   - completionHandler:
    func uploadViaHttps(url: URL, payload: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        print("payload \(payload)")
        let jsonData = try? JSONSerialization.data(withJSONObject: payload)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
        }
        task.resume()
        
    }
    
    /// upload the data using Websocket. the independent method
    /// - Parameters:
    ///   - url: url
    ///   - payload: generated by makeWebsocketPayload
    ///   - completionHandler:
    func uploadViaWebsocket(payload: [String: Any]) {
        if let jsonData = try? JSONSerialization.data(withJSONObject: payload) {
            WebSocketManager.shared.writeData(jsonData)
        }
    }
    
    
    /// upload the data timely, chose to use https and websocket automatically
    /// - Parameters:
    ///   - info:
    ///   - httpsCompletionHandler:
    ///   - websocketCompletionHandler: 
    func upload(info: String, httpsCompletionHandler: ((Data?, Error?) -> Void)?, websocketCompletionHandler: ((Data) -> Void)?) {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: interval > 0) { _ in
                if Config.shared.httpsUrl != nil {
                    guard let payload = W3bStream.makePayload(info: info) else {
                        return
                    }
                    self.uploadViaHttps(url: Config.shared.httpsUrl!, payload: payload) { data, res, err in
                        httpsCompletionHandler?(data, err)
                    }
                }
                if Config.shared.websocketUrl != nil {
                    if self.w3bWebsocketDidReceiveData == nil {
                        self.w3bWebsocketDidReceiveData = websocketCompletionHandler
                    }
                    if WebSocketManager.shared.socket == nil || WebSocketManager.shared.socket.isConnected == false {
                        WebSocketManager.shared.connnect()
                    }

                    guard let payload = W3bStream.makeWebsocketPayload(info) else {
                        return
                    }
                    self.uploadViaWebsocket(payload: payload)
                }
                
            }
        }
        timer?.fire()
    }
    
    
    /// stop the data uploading
    func stop() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
}

