import Foundation

public struct W3bHeader: Codable {
    let eventType: String
    let timestamp: Int
    let token: String
    
    func toDic() -> [String: AnyObject] {
        let encoder = JSONEncoder()
        guard let encoded = try? encoder.encode(self) else {
            return [:]
        }
        guard let result = try? encoded.jsonObject() as? [String: AnyObject] else {
            return [:]
        }
        return result!
    }
    
    public init(eventType: String, timestamp: Int, token: String) {
        self.eventType = eventType
        self.timestamp = timestamp
        self.token = token
    }
}

public extension W3bStream {
    
    func upload(url: URL?=nil, header: W3bHeader, payload: [String: Any], completionHandler: ((Data?, Error?) -> Void)?) {
        
        func dictValueToString(_ dic: [String: Any]) -> String? {
            let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
            let str = String(data: data!, encoding: String.Encoding.utf8)
            return str
        }
        
        let targetURLs = url != nil ? [url!] : Config.shared.httpsUrls
        targetURLs.forEach { url in
            
            let queryItems = [URLQueryItem(name: "eventType", value: header.eventType), URLQueryItem(name: "timestamp", value: "\(header.timestamp)")]
            var urlComps = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComps?.queryItems = queryItems
            if let _url = urlComps?.url {
                self.uploadViaHttps(url: _url, payload: payload, headers: ["Authorization": header.token, "Content-Type":"application/octet-stream"]) { data, resp, err in
                    completionHandler?(data, err)
                }
            }
        }
    }
}

