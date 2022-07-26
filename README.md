# w3bstream Framework For iOS


## Integration

Drag `build/MFWebStream.xcframework` into your project,  make sure select `Copy` option.
In `General` tab, open the _Frameworks,_ _Libraries, and Embedded Content_ section, change `Do Not Embed` to `Embed & Sign`

More details  refer to [Embedding Frameworks In An App](https://developer.apple.com/library/archive/technotes/tn2435/_index.html
)
## Usage

### Create Device

```
guard let info = MFDevice.create() else { return }
let IMEI = info.0
let SN = info.1
```

### Generate Payload
After generate payload, the ecdsa sign progress is handled internally.
```
guard let payload = DataComposeUpload.makePayload(info: data, IMEI: pebbleModel.IMEI) else { return }
```
TIP: the type of data must be json string

### Upload Data
```
DataComposeUpload.upload(url: url, payload: payload) { data, resp, err in}
```

