## Installation

### Installation with CocoaPods
Add the following line to your Podfile:
```
pod 'w3bstream', '1.0.0'
```
Then run  `pod install`  to install the dependency.

## Usage

### Create the project
To get started, follow these steps:
1. Login to w3bstream [https://mainnet.w3bstream.com/](https://mainnet.w3bstream.com/)
2. Create your project on the website
3. Generate your publisher key and token

The detail steps at [https://iotex.larksuite.com/docx/UawQd67JPopjqHxlSZmuV9HjsEh](https://iotex.larksuite.com/docx/UawQd67JPopjqHxlSZmuV9HjsEh) 

### Init the instance
Initialize the W3bstream instance with the URLs of your project, as shown below:
```   
import w3bstream

let imei
let url = "https://api.w3bstream.com/srv-applet-mgr/v0/event/yourprojectname"
let w3bStream = W3bStream(urls: [URL(string: url)!])
```

### Make the payload
Create the payload in JSON format and then encode it as Base64, as shown below:
```   
let latitude = 31.8912140
let longitude = 108.7645030
let timestamp = Int32(round(Date().timeIntervalSince1970))
let jsonstring = """
    {
        "latitude": "\(latitude)",
        "longitude": "\(longitude)",
        "timestamp": \(timestamp),
        "imei": "\(imei)"
    }
"""
let payload = jsonstring.base64Encoded()
```   


### Upload Data
Upload the payload data to your project on W3bstream using the  `upload`  method, as shown below:

```
let event_id = "yougenerateuuid" //generate by the developer
let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQYXlsb2FkIjoiMTc4MTE5MDc5NDgxNTA1OTk2OSIsImlzcyI6InczYnN0cmVhbSJ9.B1I982yTXgPTl7sfBrmDcx471Qz_1Z3fvd-5qA2VZnQ"
let pub_id = "publishkey01"
let event_id = "uuidyougenerated"
let pub_time = Int(Date().timeIntervalSince1970 * 1000)

let header = W3bHeader(eventType: "ANY", event_id: event_id, pub_id: pub_id, pub_time: pub_time, token: token)
w3bStream.upload(header: header, payload: payload, completionHandler: { data, err in
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
            let dic = json![0]
            if let wasmResults = dic["wasmResults"] as? [String: Any] {
            }
        }
}
```
### Check the result
Check the logs in the W3bstream website to view the payloads uploaded by your application. The uploaded payloads will be displayed there.

