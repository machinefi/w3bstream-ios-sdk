
import Foundation
import UIKit

public class W3bStream: NSObject {
    var w3bWebsocketDidReceiveData: ((Data)->Void)?
    public var interval = 0 //seconds
    public var timer: Timer?
    public var data: String = "" //the data string

    public override init(){
        super.init()
    }
    
    /// Create the device, generate the private key
    /// - Returns: true if successed
    public static func create() -> Bool {
        
        _ = try? MFKeychainHelper.makeAndStoreKey(name: MFKeychainHelper.PrivateKeyName)
        guard MFKeychainHelper.loadKey(name: MFKeychainHelper.PrivateKeyName) != nil else {
            print("private key failed")
            return true
        }
        return false
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
