# Usage
## Integration 
drag the MFWebStream.xcframework into your project,  ensure the copy clicked.
go to the general tab, open the _Frameworks,_ _Libraries, and Embedded Content_ section, change **Do Not Embed** to **Embed & Sign**
## Use
`import MFWebStream`
Create the device
```
guard let info = MFDevice.create() else { return }
let IMEI = info.0
let SN = info.1
```

Generate the payload, the ecdsa sign progress is handled internally.
```
guard let payload = DataComposeUpload.makePayload(info: data, IMEI: pebbleModel.IMEI) else { return }
```
TIP: the type of data must be Dictionary or JSON. the keys must be sorted (a-z)

Upload the data
```
        DataComposeUpload.upload(url: url, payload: payload) { data, resp, err in
        }
```

