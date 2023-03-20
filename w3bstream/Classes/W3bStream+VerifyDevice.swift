
import UIKit
import Foundation

extension W3bStream {
    
    /// the sign API
    /// - Parameters:
    ///   - url: the sign url
    ///   - pubKey: public key derived from keychain
    ///   - imei: imei
    ///   - sn: sn
    ///   - trulyPrivateKey: verify the unique device
    ///   - completionHandler: 
  static public func requestSign(url: URL, pubKey: String, imei:String, sn: String, trulyPrivateKey: PrivateKey, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {

      let message = ClearText(string: imei + sn + pubKey)
      do {
          let signature = try message.signed(with: trulyPrivateKey, digestType: Signature.DigestType.sha256)
          let dic = ["pubKey": pubKey, "imei": imei, "sn": sn, "signature": "\(signature.data.toHexString())"]
            let jsonData = try JSONSerialization.data(withJSONObject: dic)
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                completionHandler(data, response, error)
            }
            task.resume()
      } catch let e{
          completionHandler(nil, nil, e)
      }
    }
    
    static public func makeSignature(text: String, trulyPrivateKey: PrivateKey) -> String? {
        let message = ClearText(string: text)
        do {
            let signature = try message.signed(with: trulyPrivateKey, digestType: Signature.DigestType.sha256)
            return signature.data.toHexString()
        } catch let e{
            return nil
        }

    }
}
