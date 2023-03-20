import XCTest
@testable import MFW3bStream

class DataUploadTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
//    func testPublicKey() throws {
//
//        do {
//            var prikey: SecKey?
//            = MFKeychainHelper.loadKey(name: MFKeychainHelper.PrivateKeyName)
//            if prikey == nil {
//                prikey = try MFKeychainHelper.makeAndStoreKey(name: MFKeychainHelper.PrivateKeyName)
//            }
//            XCTAssertNotNil(prikey)
//
//            let pub = MFKeychainHelper.getPubKey(prikey!)
//            XCTAssertNotNil(pub)
//            let pubKey = MFKeychainHelper.compressedPubKey(pub!)
//            XCTAssertTrue(pubKey.count == 130)
//        }catch let e {
//            XCTAssertNotNil(nil)
//            return
//        }
//    }
    
//    func testUpload() throws {
//
//        let random = "\(Int.random(in: 10000..<99999))"
//        let number = Int32(round(Date().timeIntervalSince1970))
//        let latitudeInt = 373191214
//        let longitudeInt = -1220115882
//
//        let data = ["latitude": "\(latitudeInt)",
//                    "longitude": "\(longitudeInt)",
//                    "snr": 1024,
//                    "random": "\(random)",
//                    "number": number] as [String : Any]
//        let info = MFDevice.create()
//        XCTAssertNotNil(info)
//
//        let uploader = DataComposeUpload(url: URL(string: "https://trustream-http.onrender.com/api/data")!,
//                                         IMEI: info!.0, info: data)
//        uploader.upload { data, resp, err in
//            XCTAssertNotNil(data)
//            do{
//                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
//                let dic = json as! Dictionary<String, Any>
//                print("\(dic)")
//            }catch _ {
//                print("fail")
//            }
//        }
//
//    }
    
    func testNewUpload() {
        let w3bStream = W3bStream(urls: [URL(string: "https://example")!])
        let payload = "thetestpayload1"
        let publisherKey = "publishkey0134"
        let publisherToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJQYXlsb2FkIjoiNDUwNTMzNTg3MTM0NDY0NCIsImlzcyI6InNydi1hcHBsZXQtbWdyIiwiZXhwIjoxNjY3MzY5Mzc0fQ.0-m1rSeVL-wdhCn7OAuMa4QkopkHxvPU-q7TQQ2Em78"
        w3bStream.upload(payload:payload, publisherKey:publisherKey, publisherToken:publisherToken) { data, err in
                        XCTAssertNotNil(data)
                        do{
                            let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                            let dic = json as! Dictionary<String, Any>
                            print("\(dic)")
                            if let result = dic["results"] as? [[String: Any]] {
                                let r0 = result[0] as! [String: Any]
                                let code = r0["code"] as! Int
                                XCTAssertTrue(code == 0)
                                return
                            }
                            XCTAssertTrue(false)
                        }catch _ {
                            print("fail")
                        }
        }
    }

}