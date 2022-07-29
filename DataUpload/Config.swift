import UIKit

class Config: NSObject {
    static let shared = Config()
    var httpsUrl: URL?
    var websocketUrl: URL?
}

let imei_key = "com.mf.W3bStream.imei"
let sn_key = "com.mf.W3bStream.sn"
