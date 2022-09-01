
import Foundation
import UIKit

public class W3bStream: NSObject {
    var w3bWebsocketDidReceiveData: ((Int?, URL?, Data?, Error?)->Void)?
    
    /// init the instance
    /// - Parameter urls: https or wss url
    public init(urls: [URL] = []){
        super.init()
        guard create() else {
            fatalError("error.private key failed")
        }
        config(urls)
    }
    
    /// Create the device, generate the private key
    /// - Returns: true if successed
    func create() -> Bool {
        
        if MFKeychainHelper.loadKey(name: MFKeychainHelper.PrivateKeyName) == nil {
            _ = try? MFKeychainHelper.makeAndStoreKey(name: MFKeychainHelper.PrivateKeyName)
        }
        guard MFKeychainHelper.loadKey(name: MFKeychainHelper.PrivateKeyName) != nil else {
            return false
        }
        return true
    }
    
    /// config the url
    /// - Parameters:
    ///   - url: https or websocket
    private func config(_ urls: [URL]) {
            
        Config.shared.httpsUrls.removeAll()
        WebSocketManager.shared.disconnectAll()
        WebSocketManager.shared.socketsMap.removeAll()
        Config.shared.websocketUrls.removeAll()

        urls.forEach { url in
            if url.scheme?.lowercased() == "https" {
                Config.shared.httpsUrls.append(url)
            }else if url.scheme?.lowercased() == "wss" {
                Config.shared.websocketUrls.append(url)
                buildWebsocketConnect(url)
            }
        }
        
    }
    
    /// config the websocket url,  the connect will be built then
    /// - Parameters:
    ///   - url: websocket url
    private func buildWebsocketConnect(_ url: URL) {
        WebSocketManager.shared.addConnect(url)
        WebSocketManager.shared.websocketDidReceiveData = nil
        WebSocketManager.shared.websocketDidReceiveData = { [weak self] tag, url, data, err in
            self?.w3bWebsocketDidReceiveData?(tag, url, data, err)
        }
    }
    
    /// update the urls
    /// - Parameter urls: https or wss url
    public func updateURLs(_ urls: [URL]) {
        config(urls)
    }
    
    
    /// generate the signature with private key. data is the original data
    /// - Parameter data: Data
    /// - Returns: signature
    public static func sign(_ data: Data) -> Data? {
        let hash = data.sha256()
        guard let privateKey = MFKeychainHelper.loadKey(name: MFKeychainHelper.PrivateKeyName) else {
            print("load key failed")
            return nil
        }
        do {
            guard let signature = try MFKeychainHelper.createSignature(privateKey, algorithm: .ecdsaSignatureDigestX962SHA256, hashData: hash) else {
                return nil
            }
            return signature
        }catch let e {
            print(e)
        }
        return nil
    }
    
}
