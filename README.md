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
Initialize the W3bstream instance with the URLs of your project, as shown below.:
```   
import w3bstream
let url = "http://dev.w3bstream.com:8889/srv-applet-mgr/v0/event/eth_0x2ee1d96cb76579e2c64c9bb045443fb3849491d2_geo_example_claim_nft"
let w3bStream = W3bStream(urls: [URL(string: url)!])
```

### Make the payload
Create the payload, the content is arbitrary. For example, we upload the designated location and the wallet address to receive the nft from the w3bstream service .
```   
let timestamp = Int32(round(Date().timeIntervalSince1970))
let latitude = 100
let longitude = 100
let imei
let walletAddress = "0x2eE1d96CB76579e2c64C9BB045443Fb3849491D2"
        
var dic: [String: Any] = [
        "latitude": "\(latitude)",
        "longitude": "\(longitude)",
        "timestamp": timestamp,
        "imei": imei,
        "walletAddress": walletAddress
    ]
        
let payload = dic
```   


### Upload Data
Upload the payload data to your project on W3bstream using the  `upload`  method, as shown below:

```
let token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQYXlsb2FkIjoiOTAyNTQ3MTgxNzYxMDI0NSIsImlzcyI6InczYnN0cmVhbSJ9.8uY4gGMBk4bJwyBsqTY3wGqMPnfSIggfw54k0ln6fwY"
let eventType = "DEFAULT"
let timestamp = Int(Date().timeIntervalSince1970 * 1000)

let header = W3bHeader(eventType: eventType, timestamp: timestamp, token: token)
w3bStream.upload(header: header, payload: payload, completionHandler: { data, err in
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]{
        }
})
```
### Check the result
Check the logs in the W3bstream website to view the payloads uploaded by your application. The uploaded payloads will be displayed there.

