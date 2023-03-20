## Installation

There are two ways to use w3bStream in your project:

-   using CocoaPods
-   using the xcframework
### Installation with CocoaPods

```
pod 'w3bstream'
```


###  Integration with xcframework
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
