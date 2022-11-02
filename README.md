# w3bstream Framework For iOS

## Integration
Open the out folder, drag `MFW3bStream.xcframework` into your project, make sure select `Copy` option.It is built with Xcode 14 and supporting all platforms (arm, x86).
If you installed the Xcode with previous version, run the makeframework.sh.

## Usage

### Init the instance
```   let w3bStream = W3bStream(urls: [URL(string: "https://xxxxx")!])
```

### Upload Data
```
w3bStream.upload(payload: ["xx": "xx"], pubKey: "xxx", pubToken: "xxx") { data, err in
} 
```
