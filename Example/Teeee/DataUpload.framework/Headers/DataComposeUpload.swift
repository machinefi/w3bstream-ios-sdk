//
//  DataComposeUpload.swift
//  DataUpload
//
//  Created by yuan zeng on 2022/6/29.
//

import Foundation

public class DataComposeUpload: NSObject{
    
    
    /// make the upload payload
    /// - Parameters:
    ///   - info: the keys must be sorted ,a - b - c - d
    ///   - IMEI: device IMEI
    /// - Returns: description
    public static func makePayload(info: [String: Any], IMEI: String) -> [String: Any]? {

        guard let jsonData  = try? JSONSerialization.data(withJSONObject: info, options: [.sortedKeys]) else {
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
        
    public static func upload(url: URL, payload: [String: Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
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
}

