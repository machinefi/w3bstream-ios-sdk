# w3bstream Framework For iOS

## Integration
Open the out folder, drag `MFW3bStream.xcframework` into your project, make sure select `Copy` option.It is built with Xcode 14 and supporting all platforms (arm, x86).
If you installed the Xcode with previous version, run the makeframework.sh.

## Usage

### Init the instance
```   
let w3bStream = W3bStream(urls: [URL(string: "https://example")!])
```

### Upload Data
```
w3bStream.upload(payload: "payload", publisherKey:"key", publisherToken:"token") { data, err in
}
```
