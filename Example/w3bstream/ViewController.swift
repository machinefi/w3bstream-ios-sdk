import UIKit
import Toast_Swift
import SnapKit
import SwiftLocation
import CoreLocation
import w3bstream

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
    @IBOutlet weak var intervaltf: UITextField!
    @IBOutlet weak var tokenField: UITextField!
    @IBOutlet weak var walletAddresstf: UITextField!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    var timer: Timer?
    var hisvc = HistoryViewController()
    var imei: String = ""
    var w3bStream: W3bStream?
    var coordinate: CLLocationCoordinate2D?
    var json = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imei = "100" + String("\(Int(arc4random_uniform(899999) + 100000))") + String("\(Int(arc4random_uniform(899999) + 100000))")
        intervaltf.text = "50"
        addChildViewController(hisvc)
        containerView.addSubview(hisvc.view)
        hisvc.view.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        SwiftLocation.gpsLocation().then {
            print("gpsLocation requested \(Date().description)")
            self.coordinate = $0.location?.coordinate
            self.makeNewData()
        }
    }
    
    
    @IBAction func upload(_ sender: Any) {
        
        if uploadBtn.isSelected {
            uploadBtn.isSelected = false
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            self.view.makeToast("upload stopped")
            return
        }
        
        let eventType = "DEFAULT"
        let token = tokenField.text!

        if let url = URL(string: urlField.text!), w3bStream == nil {
            w3bStream = W3bStream(url: url, eventType: eventType, token: token)
        }
        
        uploadBtn.isSelected = true
        makeNewData()
        let interval = (intervaltf.text?.isEmpty ?? true) ? 0 : Int(intervaltf.text!)!
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: interval > 0) { _ in
                
                self.w3bStream?.upload(payload: self.json, completionHandler: { data, err in
                    guard let data = data else {
                        print("\(err)")
                        return
                    }
                    let stringValue = String(decoding: data, as: UTF8.self)
                    print("\(stringValue)")
                    DispatchQueue.main.async {
                        self.hisvc.reloadData()
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                            let dic = json![0]
                            if let wasmResults = dic["wasmResults"] as? [String: Any] {
                                DispatchQueue.main.async {
                                    self.view.makeToast("Upload success")
                                }
                            }
      
                        }else {
                            DispatchQueue.main.async {
                                self.view.makeToast("Upload faild")
                            }
                        }
                    }
                    
                })

            }
        }
        timer?.fire()
         
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    
    @IBAction func his(_ sender: Any) {
        self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    
    func makeNewData(){
        let timestamp = Int32(round(Date().timeIntervalSince1970))
        let latitude = 100
        let longitude = 100
        
        var dic: [String: Any] = [
            "latitude": "\(latitude)",
            "longitude": "\(longitude)",
            "timestamp": timestamp,
            "imei": "\(imei)"
        ]
        
        if let walletAddress = walletAddresstf.text {
            dic["walletAddress"] = walletAddress
        }
        
        json = dic
        dataLabel.text = "latitude: \(latitude), longitude: \(longitude)"
    }
}


extension String {
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
}
