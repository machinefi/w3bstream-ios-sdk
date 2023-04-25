import Foundation

public struct W3bHeader: Codable {
    let event_type: String
    let event_id: String
    let pub_id: String
    let pub_time: Int
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
    
    public init(event_type: String, event_id: String, pub_id: String, pub_time: Int, token: String) {
        self.event_type = event_type
        self.event_id = event_id
        self.pub_id = pub_id
        self.pub_time = pub_time
        self.token = token
    }
}

public extension W3bStream {
    
    func upload(url: URL?=nil, header: W3bHeader, payload: String, completionHandler: ((Data?, Error?) -> Void)?) {
        
        func dictValueToString(_ dic: [String: Any]) -> String? {
            let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
            let str = String(data: data!, encoding: String.Encoding.utf8)
            return str
        }
        
        let targetURLs = url != nil ? [url!] : Config.shared.httpsUrls
        targetURLs.forEach { url in
             let dic = [
                "events":[
                    ["header": header.toDic(),
                     "payload": payload
                    ] as [String : Any]
             ]
            ]
            self.uploadViaHttps(url: url, payload: dic) { data, resp, err in
                completionHandler?(data, err)
            }
        }
    }
}

