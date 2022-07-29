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

class ViewController: UIViewController {
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var intervaltf: UITextField!
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var tf2: UITextField!
    var w3bStream: W3bStream = W3bStream()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tf1.text = "https://trustream-http.onrender.com/api/data"
        tf2.text = "wss://w3w3bstream-example.onrender.com/"
    }

    @IBAction func createdevice(_ sender: Any) {
        //create the device
        let device = W3bStream.create()!
        deviceLabel.text = "device imei=\(device.IMEI) sn=\(device.SN)"
        w3bStream.interval = Int(intervaltf.text ?? "") ?? 0

    }
    
    @IBAction func upload(_ sender: Any) {

        let httpsurl = (tf1.text ?? "").isEmpty ? nil : URL(string: tf1.text!)!
        let wsurl = (tf2.text ?? "").isEmpty ? nil : URL(string: tf2.text!)!
        
        if httpsurl == nil && wsurl == nil {
            print("check the url")
            return
        }

        w3bStream.config(httpsurl, websocketUrl: wsurl)

        //prepare the data
        let random = "\(Int.random(in: 10000..<99999))"
        let timestamp = Int32(round(Date().timeIntervalSince1970))
        let latitudeInt = 295661300
        let longitudeInt = 1064685700
        let jsonString = "{\"latitude\":\"\(latitudeInt)\",\"longitude\":\"\(longitudeInt)\",\"random\":\"\(random)\",\"snr\": 1024,\"timestamp\":\(timestamp)}"
        

        w3bStream.upload(info: jsonString) { data, err in
            
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
}

