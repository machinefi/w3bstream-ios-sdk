# w3bstream Framework For iOS

## Make the framework
Before running the Demo, the developer must generate the framework according to their own macOS environment 
Run the makeframework.sh, the framworks will be generated in the build directory, which support ARM and x86 both.

## Integration
If running your project on the simulator, drag `build/Release-iphonesimulator/W3bStream.framework` into your project,  make sure select `Copy` option. If runnging on the device or submitting to Appstore, please use `build/Release-iphoneos/W3bStream.framework`. If you encouter unexceptions of Privatekey when using `build/Release-iphonesimulator/W3bStream.framework`, please try the device.
In `General` tab, open the _Frameworks,_ _Libraries, and Embedded Content_ section, change `Do Not Embed` to `Embed & Sign`

More details  refer to [Embedding Frameworks In An App](https://developer.apple.com/library/archive/technotes/tn2435/_index.html)
## Usage

### Init the instance

Create the instance
```
   let httpsurl1 = URL(string: "https://xxxxx")!
   let httpsurl2 = URL(string: "https://xxxxx")!
   let httpsurl3 = URL(string: "https://xxxxx")!
   let wsurl = URL(string: "wss://xxxxx")!
   let urls = [httpsurl1, httpsurl2, httpsurl3, wsurl]
   let w3bStream = W3bStream(urls: urls)
```

### Upload Data
```
//prepare the data
let jsonString = "{\"latitude\":\"36.652061\",\"longitude\":\"117.120144\",\"shakeCount\": 4,\"timestamp\":1660027882, \"imei\":\"100558946403437\"}"
//upload
w3bStream.upload(data: jsonString) { data, err in
} 
```

## Other
You can also use only some of the capabilities in the SDK. 
### Sign
generate the signature with private key stored in the keychain and ABI encoding
```
let jsonData = "xxxx".data(using: .utf8)
let signature = W3bStream.sign(jsonData)
```
### Update the urls
```
   let httpsurl = URL(string: "https://xxxxx")!
   let wsurl = URL(string: "wss://xxxxx")!
   let urls = [httpsurl, wsurl]
   w3bStream.update(urls)
```
### Sign request
sign API demonstrates how to verify the unique device
check the usage in the Demo


## Run the demo
run `makeframework.sh` first, then `pod install` in the Example, open the Demo.xcworkspace
