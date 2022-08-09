# w3bstream Framework For iOS

## Make the framework
Run the makeframework.sh, the framworks will be generated in the build directory, which support ARM and x86 both.

## Integration
If running your project on the simulator, drag `build/Release-iphonesimulator/W3bStream.framework` into your project,  make sure select `Copy` option. If runnging on the device or submitting to Appstore, please use `build/Release-iphoneos/W3bStream.framework`. If you encouter unexceptions of Privatekey when using `build/Release-iphonesimulator/W3bStream.framework`, please try the device.
In `General` tab, open the _Frameworks,_ _Libraries, and Embedded Content_ section, change `Do Not Embed` to `Embed & Sign`

More details  refer to [Embedding Frameworks In An App](https://developer.apple.com/library/archive/technotes/tn2435/_index.html)
## Usage

### Create Device

Create the private key (stored in the keychain)
```
  let isOk = W3bStream.create()
```

### Sign request
sign API demonstrates how to verify the unique device
check the usage in the Demo

### Config  
```
let httpsurl = URL(string: "https://xxxxx")!
let wsurl = URL(string: "wss://xxxxx")!
w3bStream.config(httpsurl, websocketUrl: wsurl)
w3bStream.interval = 5 //5 seconds
//Cause the websocket costs time on connecting, we recommend to build the websocket initially 
w3bStream.buildWebsocketConnect(wsurl!)

```
 The https url and websocket url are optional. But  one  must be set at least.
 If interval is greater than 0. The upload action will be repeated in specified seconds. The default is 0.
### Upload Data
```
//prepare the data
let jsonString = "{\"latitude\":\"36.652061\",\"longitude\":\"117.120144\",\"shakeCount\": 4,\"timestamp\":1660027882, \"imei\":\"100558946403437\"}"
//update the data 
w3bStream.data = jsonString
//upload
w3bStream.upload { data, err in
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

## Run the demo
run `makeframework.sh` first, then `pod install` in the Example, open the Demo.xcworkspace