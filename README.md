## Installation

### Installation with CocoaPods

```
pod 'w3bstream', '1.0.0'
```

## Usage

### Create the project
Open the website https://mainnet.w3bstream.com/ 
Create the project, generate the publisher key and token
Tip: the help document https://docs.w3bstream.com/introduction/readme 

### Init the instance
```   
import w3bstream

let imei
let url = "https://api.w3bstream.com/srv-applet-mgr/v0/event/yourprojectname"
let w3bStream = W3bStream(urls: [URL(string: url)!])
```

### Make the payload
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

```
let event_id = "yougenerateuuid" //generate by the developer
let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQYXlsb2FkIjoiMTc4MTE5MDc5NDgxNTA1OTk2OSIsImlzcyI6InczYnN0cmVhbSJ9.B1I982yTXgPTl7sfBrmDcx471Qz_1Z3fvd-5qA2VZnQ"
let pub_id = "publishkey01"
let event_id = "uuidyougenerated"
let pub_time = Int(Date().timeIntervalSince1970 * 1000)

let header = W3bHeader(event_type: "ANY", event_id: event_id, pub_id: pub_id, pub_time: pub_time, token: token)
w3bStream.upload(header: header, payload: payload, completionHandler: { data, err in
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
            let dic = json![0]
            if let wasmResults = dic["wasmResults"] as? [String: Any] {
            }
        }
}
```
### Check the result
Open the log in the W3bstream website. The payloads uploaded are displayed there
