
import Foundation
import UIKit

public class W3bStream: NSObject {
    var w3bWebsocketDidReceiveData: ((Data)->Void)?
    public var interval = 0 //seconds
    public var timer: Timer?
    
    public override init(){
        super.init()
    }
    
    /// Create the device
    /// - Returns: IMEI and SN
    public static func create() -> (IMEI: String, SN: String)? {
        func randomString(of length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var s = ""
            for _ in 0 ..< length {
                s.append(letters.randomElement()!)
            }
            return s
        }
        
        let IMEI = "100" + String("\(Int(arc4random_uniform(899999) + 100000))") + String("\(Int(arc4random_uniform(899999) + 100000))")
        let SN = randomString(of: 10).uppercased()
        guard IMEI.count == 15 && SN.count == 10 else {
            print("IMEI.count == 15 && SN.count == 10")
            return nil
        }
        
        KeychainWrapper.standard.removeObject(forKey: imei_key)
        KeychainWrapper.standard.removeObject(forKey: sn_key)
        
        KeychainWrapper.standard.set(IMEI, forKey: imei_key)
        KeychainWrapper.standard.set(SN, forKey: sn_key)
        return (IMEI, SN)
        
    }
    
    /// config the url
    /// - Parameters:
    ///   - httpsUrl: https url, optional
    ///   - websocketUrl: websocket url, optional
    public func config(_ httpsUrl: URL?=nil, websocketUrl: URL?=nil) {
        if httpsUrl != nil {
            Config.shared.httpsUrl = httpsUrl
        }
        if websocketUrl != nil {
            Config.shared.websocketUrl = websocketUrl
            buildWebsocketConnect(websocketUrl!)

        }
    }
    
    /// config the websocket url,  the connect will be built then
    /// - Parameters:
    ///   - url: websocket url
    public func buildWebsocketConnect(_ url: URL) {
        Config.shared.websocketUrl = url
        WebSocketManager.shared.connnect()
        WebSocketManager.shared.websocketDidReceiveData = { [weak self] data in
            self?.w3bWebsocketDidReceiveData?(data)
        }
    }
    
}
