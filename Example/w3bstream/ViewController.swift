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
    @IBOutlet weak var tokenField: UITextView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var payload: UITextView!
    @IBOutlet weak var result: UITextView!

    @IBOutlet weak var uploadBtn: UIButton!
    
    var imei: String = ""
    var w3bStream: W3bStream?
    var coordinate: CLLocationCoordinate2D?
    var json = [String: Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imei = "100" + String("\(Int(arc4random_uniform(899999) + 100000))") + String("\(Int(arc4random_uniform(899999) + 100000))")

        SwiftLocation.gpsLocation().then {
            print("gpsLocation requested \(Date().description)")
            self.coordinate = $0.location?.coordinate
        }
        
        tokenField.layer.borderColor = UIColor.lightGray.cgColor
        tokenField.layer.borderWidth = 1
        tokenField.layer.cornerRadius = 8
        
        payload.layer.borderColor = UIColor.lightGray.cgColor
        payload.layer.borderWidth = 1
        payload.layer.cornerRadius = 8
        
        result.layer.borderColor = UIColor.lightGray.cgColor
        result.layer.borderWidth = 1
        result.layer.cornerRadius = 8
        result.isEditable = false
    }
    
    
    @IBAction func upload(_ sender: Any) {
        
        let eventType = "DEFAULT"
        let token = tokenField.text!

        let data = payload.text.data(using: .utf8)!
        let json = try! JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
        
        
        if let url = URL(string: urlField.text!), w3bStream == nil {
            w3bStream = W3bStream(url: url, eventType: eventType, token: token)
        }

        self.w3bStream?.upload(payload: self.json, completionHandler: { data, err in
            guard let data = data else {
                print("\(err)")
                return
            }
                
            let stringValue = String(decoding: data, as: UTF8.self)
            print("\(stringValue)")
            DispatchQueue.main.async {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
                    self.result.text = stringValue
                }else {
                    self.result.text = err?.localizedDescription
                }
            }

        })

        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
}
