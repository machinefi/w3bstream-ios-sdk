import UIKit
class WebSocketManager: NSObject {

    static let shared = WebSocketManager()
    var socket: WebSocket!
    var websocketDidReceiveData: ((Data)->Void)?

    func connnect() {
        guard let websocketUrl = Config.shared.websocketUrl else {
            return
        }
        var request = URLRequest(url: websocketUrl)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    func disconnect() {
        socket.disconnect()
    }
    func writeData(_ data: Data) {
        socket.write(data: data)
    }
}

extension WebSocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient){
        
    }
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?){
    }
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String){
        let data = Data(text.utf8)
        print("websocketDidReceiveData \(text)")
        websocketDidReceiveData?(data)
    }
    func websocketDidReceiveData(socket: WebSocketClient, data: Data){
        let str = String(decoding: data, as: UTF8.self)
        print("websocketDidReceiveData \(str)")
        websocketDidReceiveData?(data)
    }
}
