import UIKit
import W3bStream

extension Dictionary {
    
    func toJsonString() -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self,
                                                     options: []) else {
            return nil
        }
        guard let str = String(data: data, encoding: .utf8) else {
            return nil
        }
        return str
     }
    
}

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var imeitf: UITextField!
    @IBOutlet weak var sntf: UITextField!
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var intervaltf: UITextField!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    var w3bStream: W3bStream = W3bStream()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = W3bStream.create()
        
        tf1.text = nil
        tf2.text = nil
        tf2.delegate = self
        tf1.delegate = self
    }
    
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tf1.endEditing(true)
        if textField == tf2 {
            tf2.endEditing(true)
            let wsurl = (tf2.text ?? "").isEmpty ? nil : URL(string: tf2.text!)!
            if wsurl != nil {
                w3bStream.buildWebsocketConnect(wsurl!)
            }
        }
        return true
    }
 
    @IBAction func upload(_ sender: Any) {
        let httpsurl = (tf1.text ?? "").isEmpty ? nil : URL(string: tf1.text!)!
        w3bStream.config(httpsurl)
            //prepare the data
            let random = "\(Int.random(in: 10000..<99999))"
            let timestamp = Int32(round(Date().timeIntervalSince1970))
            let latitudeInt = 295661300
            let longitudeInt = 1064685700
            let jsonString = "{\"latitude\":\"\(latitudeInt)\",\"longitude\":\"\(longitudeInt)\",\"random\":\"\(random)\",\"snr\": 1024,\"timestamp\":\(timestamp)}"
            

            self.w3bStream.upload(info: jsonString) { data, err in
                
                                guard let data = data else {
                                    return
                                }
                                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                let dic = json as! Dictionary<String, Any>
                                print("https res \(dic)")
                
            } websocketCompletionHandler: { data in
                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                let dic = json as! Dictionary<String, Any>
                print("websocket res \(dic)")
            }
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

