
import Foundation

public class MFDevice: NSObject {
    public static func create() -> (String, String)? {
        func randomString(of length: Int) -> String {
            let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var s = ""
            for _ in 0 ..< length {
                s.append(letters.randomElement()!)
            }
            return s
        }
        
        let IMEI = "100" + String("\(Int(arc4random_uniform(899999) + 100000))") + String("\(Int(arc4random_uniform(899999) + 100000))")
        let SN = randomString(of: 10).uppercased()
        guard IMEI.count == 15 && SN.count == 10 else {
            print("IMEI.count == 15 && SN.count == 10")
            return nil
        }
        return (IMEI, SN)
        
    }
}
