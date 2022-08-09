import UIKit
import W3bStream

class SignViewController: UIViewController {

    @IBOutlet weak var imeiLabel: UILabel!
    @IBOutlet weak var snLabel: UILabel!
    @IBOutlet weak var pubkeyLabel: UILabel!
    @IBOutlet weak var signUrlField: UITextField!
    @IBOutlet weak var textView: UITextView!

    var imei = ""
    var sn = ""
    var pubKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let vc = navigationController?.viewControllers.first as? ViewController {
            imei = vc.imeitf.text ?? ""
            sn = "afzxxvq3124"  //random string
            imeiLabel.text = "IMEI: " + imei
            snLabel.text = "SN: " +  sn
            pubKey = MFKeychainHelper.compressedPubKey(MFKeychainHelper.getCurrentPubKey() ?? "")
            pubkeyLabel.text = "PUBKEY: " + pubKey
        }
        
        signUrlField.text = "https://trustream-http.onrender.com/api/sign"
        
        textView.text = """
        -----BEGIN RSA PRIVATE KEY-----
        MIICXQIBAAKBgQCmtGpLM8mAk9zpHPxFGY9QsAWckIIr97WZMa6V0wMP3tC0nAGW
        XwVmUo7dAcO7CkT/mOIspcpKfH+pSl1mtGqWwPi8YZxmsISTZRWbMr4gNUfyJBTd
        FyUKSifdoM4E/WjBYYNAhUI2e1Aw1C2mIp1linlyd4Wc7IvMarPQRhJnqQIDAQAB
        AoGBAJEwuw8KaKqCnbmuVAz+yPJ2jDyjI6yVjuWA/tRgtt8AqfdTlJJZ6gMHToQw
        QD/MHvIaPoqyTrB3JFzWdui3o8iGPStCgHKyNYzkjxfOog28AEce4qGfDjjRdsnG
        KcgaALmI37JztNvVlj88ljqOl31QsgjubvShQBgrrDYZmyYNAkEA3e/A8/4YrYAD
        faqtFrmlxhReE/8vUu3ArzB9o7K3HGpB7WfgFCNuG2NDJL54aUO/WADv06eQPMFQ
        y0y6omZ1fwJBAMBKg9B8vzp96HypOIanXP++kFk36R0RueJw9B6xQmg9jgJbZhh9
        k1QW1Szp81/0aNGlkF3bWpFn/qBdgEabRtcCQCpRHKlpOatbTU8YzAgZPdKW75lA
        fvWA/8xnoo0j9mYknI130PIGD2iJdLP83Vi04jcVdqUUvhvXgGBDMRLmFmECQAY/
        5bzW8Rgjk3TJwy6NLfaZ6PMdYBQzyUjUxvpgZHoi1gS5l73gBvPKsi79g41w0h9O
        NDz4rh7ftGTd5RdmYI0CQQCq1/uMWEwQNAQohUq782p4vz7ARJsv/h/pv6xwTOEC
        4X0ei9LM8FjebvMPb8YOqhsEMZ+A6IoNYsxHZYRmzdkW
        -----END RSA PRIVATE KEY-----
        """
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sign(_ sender: Any) {
        guard let pri = PrivateKey(pemEncoded: textView.text) else {
            return
        }
        
        W3bStream.requestSign(url: URL(string: signUrlField.text!)!, pubKey: pubKey,
                              imei: imei, sn: sn, trulyPrivateKey: pri) { data, res, err in
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            print("requestSign res \(dic)")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
