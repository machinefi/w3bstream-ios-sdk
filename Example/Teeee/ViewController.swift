//
//  ViewController.swift
//  Teeee
//
//  Created by yuan zeng on 2022/6/30.
//

import UIKit
import MFWebStream

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

    override func viewDidLoad() {
        super.viewDidLoad()
    
        //create the device
        let device = MFDevice.create()!
        
        //prepare the data
        let random = "\(Int.random(in: 10000..<99999))"
        let timestamp = Int32(round(Date().timeIntervalSince1970))
        let latitudeInt = 295661300
        let longitudeInt = 1064685700
        let jsonString = "{\"latitude\":\"\(latitudeInt)\",\"longitude\":\"\(longitudeInt)\",\"random\":\"\(random)\",\"snr\": 1024,\"timestamp\":\(timestamp)}"
        
        let url = URL(string: "https://trustream-http.onrender.com/api/data")!

        //make the payload
        guard let payload = DataComposeUpload.makePayload(info: jsonString, IMEI: device.0) else {
            return
        }
        
        //upload the data
        DataComposeUpload.upload(url: url, payload: payload) { data, resp, err in
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                let dic = json as! Dictionary<String, Any>
                print("\(dic)")
            }catch _ {
                print("fail")
            }
        }

    }


}

