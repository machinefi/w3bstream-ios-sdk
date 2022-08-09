import UIKit

class Config: NSObject {
    static let shared = Config()
    var httpsUrls: [URL] = []
    var websocketUrls: [URL] = []
}

let imei_key = "com.mf.W3bStream.imei"
let sn_key = "com.mf.W3bStream.sn"
