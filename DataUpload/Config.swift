import UIKit

class Config: NSObject {
    static let shared = Config()
    var httpsUrls: [URL] = []
    var websocketUrls: [URL] = []
}
