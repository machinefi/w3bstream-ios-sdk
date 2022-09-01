import UIKit
class WebSocketManager: NSObject {

    static let shared = WebSocketManager()
    var websocketDidReceiveData: ((Int?, URL?, Data?, Error?)->Void)?
    var socketsMap = [String: WebSocket]()

    func addConnect(_ url: URL) {
        if socketsMap[url.absoluteString] == nil {
            socketsMap[url.absoluteString] = makeConnnect(url)
        }
    }
    
    private func makeConnnect(_ url: URL) -> WebSocket {
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
        return socket
    }
    func disconnect(_ url: URL) {
        if let socket = socketsMap[url.absoluteString] {
            socket.disconnect()
        }
    }
    
    func disconnectAll() {
        socketsMap.values.forEach { socket in
            socket.disconnect()
        }
    }
    
    func writeData(_ data: Data) {
        socketsMap.values.forEach { socket in
            socket.write(data: data)
        }
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
        websocketDidReceiveData(socket: socket, data: data)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data){
        let str = String(decoding: data, as: UTF8.self)
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        let tag = json?["id"] as? Int
        print("websocketDidReceiveData \(str)")
        websocketDidReceiveData?(tag, (socket as! WebSocket).request.url, data, nil)
    }
    
}
