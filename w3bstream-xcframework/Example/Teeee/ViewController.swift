import UIKit
import W3bStream
import Toast_Swift
import SnapKit
import SwiftLocation
import CoreLocation

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
    @IBOutlet weak var tf1: UITextField!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    var timer: Timer?
    var hisvc = HistoryViewController()
    
    var w3bStream: W3bStream?
    var shakeCounter = 0
    var coordinate: CLLocationCoordinate2D?
    var jsonstring = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let IMEI = "100" + String("\(Int(arc4random_uniform(899999) + 100000))") + String("\(Int(arc4random_uniform(899999) + 100000))")
        imeitf.text = IMEI
        intervaltf.text = "10"
        tf1.text = "https://w3bstream-shake-demo.onrender.com/api/data"
        tf1.delegate = self
        addChild(hisvc)
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
        
        guard tf1.text?.isEmpty == false else {
            self.view.makeToast("https/websocket cannot be empty")
            return
        }
        
        if tf1.text?.isEmpty == false, let url = URL(string: tf1.text!), w3bStream == nil {
            w3bStream = W3bStream(urls: [url])
        }
        
        uploadBtn.isSelected = true
        
        makeNewData()
        let latitude = coordinate?.latitude ?? 0
        let longitude = coordinate?.longitude ?? 0
        let interval = (intervaltf.text?.isEmpty ?? true) ? 0 : Int(intervaltf.text!)!
        
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: interval > 0) { _ in
                self.w3bStream!.upload(data: self.jsonstring) {tag, url, data, err in
                    
                    DispatchQueue.main.async {
                        DataModel(shakeCount: self.shakeCounter, timestamp: Date().timeIntervalSince1970, latitude: "\(latitude)", longitude: "\(longitude)").add()
                        self.hisvc.reloadData()
                        guard let data = data else {
                            return
                        }
                        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                            let dic = json as! Dictionary<String, Any>
                            print("https res \(dic)")
                            DispatchQueue.main.async {
                                self.view.makeToast("Upload success")
                            }
                        }else {
                            DispatchQueue.main.async {
                                self.view.makeToast("Upload success")
                            }
                        }
                        self.shakeCounter = 0
                    }
                                
                }
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
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shakeCounter += 1
            print("Shaken \(shakeCounter) times")
            makeNewData()
        }
    }
    
    
    @IBAction func his(_ sender: Any) {
        self.navigationController?.pushViewController(HistoryViewController(), animated: true)
    }
    
    func makeNewData(){
        let timestamp = Int32(round(Date().timeIntervalSince1970))
        let latitude = coordinate?.latitude ?? 0
        let longitude = coordinate?.longitude ?? 0
        jsonstring = "{\"latitude\":\"\(latitude)\",\"longitude\":\"\(longitude)\",\"shakeCount\": \(shakeCounter),\"timestamp\":\(timestamp), \"imei\":\"\(imeitf.text!)\"}"
        dataLabel.text = "latitude: \(latitude), longitude: \(longitude), shakeCount: \(shakeCounter)"
    }
}
