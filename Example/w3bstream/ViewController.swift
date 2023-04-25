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
    @IBOutlet weak var imeitf: UITextField!
    @IBOutlet weak var intervaltf: UITextField!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    var timer: Timer?
    var hisvc = HistoryViewController()
    
    var w3bStream: W3bStream?
    var coordinate: CLLocationCoordinate2D?
    var jsonstring = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let IMEI = "100" + String("\(Int(arc4random_uniform(899999) + 100000))") + String("\(Int(arc4random_uniform(899999) + 100000))")
        imeitf.text = IMEI
        intervaltf.text = "10"
        urlLabel.text = "https://api.w3bstream.com/srv-applet-mgr/v0/event/iostest1"
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
        
        guard imeitf.text?.isEmpty == false else {
            self.view.makeToast("IMEI cannot be empty")
            return
        }
        
        
        if let url = URL(string: urlLabel.text!), w3bStream == nil {
            w3bStream = W3bStream(urls: [url])
        }
        
        uploadBtn.isSelected = true
        makeNewData()
        let interval = (intervaltf.text?.isEmpty ?? true) ? 0 : Int(intervaltf.text!)!
        let payload = self.jsonstring.base64Encoded() ?? ""
        let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQYXlsb2FkIjoiMTc4MTE5MDc5NDgxNTA1OTk2OSIsImlzcyI6InczYnN0cmVhbSJ9.B1I982yTXgPTl7sfBrmDcx471Qz_1Z3fvd-5qA2VZnQ"
        let pub_id = "publishkey01"
        let event_id = "uuidyougenerated"
        let pub_time = Int(Date().timeIntervalSince1970 * 1000)
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: interval > 0) { _ in
                
                let header = W3bHeader(event_type: "ANY", event_id: event_id, pub_id: pub_id, pub_time: pub_time, token: token)
                self.w3bStream?.upload(header: header, payload: payload, completionHandler: { data, err in
                    let stringValue = String(decoding: data!, as: UTF8.self)
                    print("\(stringValue)")
                    DispatchQueue.main.async {
                        self.hisvc.reloadData()
                        guard let data = data else {
                            return
                        }
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
        let latitude = coordinate?.latitude ?? 0
        let longitude = coordinate?.longitude ?? 0
        jsonstring = """
    {
        "latitude": "\(latitude)",
        "longitude": "\(longitude)",
        "timestamp": \(timestamp),
        "imei": "\(imeitf.text!)"
    }
"""
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
