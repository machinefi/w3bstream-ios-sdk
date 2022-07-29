# w3bstream Framework For iOS

## Integration
If running your project on the simulator, drag `build/Simulator/W3bStream.framework` into your project,  make sure select `Copy` option. If runnging on the device or submitting to Appstore, please use `build/ios/W3bStream.framework`.
In `General` tab, open the _Frameworks,_ _Libraries, and Embedded Content_ section, change `Do Not Embed` to `Embed & Sign`

More details  refer to [Embedding Frameworks In An App](https://developer.apple.com/library/archive/technotes/tn2435/_index.html)
## Usage

### Create Device

```
  let device = W3bStream.create()!
  let imei = device.IMEI
  let sn= device.SN
```
### Config  
```
let httpsurl = URL(string: "https://xxxxx")!
let wsurl = URL(string: "wss://xxxxx")!
w3bStream.config(httpsurl, websocketUrl: wsurl)
w3bStream.interval = 5 //5 seconds
```
 The https url and websocket url are optional. But  one  must be set at least.
 If interval is greater than 0. The upload action will be repeated in specified seconds. The default is 0.
### Upload Data
```
//prepare the data
let random = 51652
let timestamp = 1658998925
let latitudeInt = 295661300
let longitudeInt = 1064685700
let jsonString = "{\"latitude\":\"\(latitudeInt)\",\"longitude\":\"\(longitudeInt)\",\"random\":\"\(random)\",\"snr\": 1024,\"timestamp\":\(timestamp)}"
//upload
w3bStream.upload(info: jsonString) { data, err in
} websocketCompletionHandler: { data in
}
```

### Other
You can also use only some of the capabilities in the SDK. 
#### Generate Payload  
```
let payload = W3bStream.makePayload(info: info) 
```
TIP: the type of info must be json string
####  independent Upload behaviour
Https upload method
```
uploadViaHttps(url: URL, payload: payload) { data, res, err in
                        httpsCompletionHandler?(data, err)
                    }
```
websocket upload method
```
uploadViaWebsocket(payload: payload)
```


