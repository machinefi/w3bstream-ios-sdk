import Foundation

public extension MFKeychainHelper {
    static func makeSignatureWithABIEncoding(_ privateKey: SecKey, hash: Data) -> Data? {
        guard let cipherData = MFKeychainHelper.createSignature(privateKey, algorithm: .ecdsaSignatureDigestX962SHA256, hashData: hash) else {
            return nil
        }
        let sigString = cipherData.hexEncodedString()
        let xlength = 2 * Int(sigString.subString(start:6, length: 2), radix: 16)!
        let newSigString = sigString.subString(start: 8)
        let arr = [
            BigInt(newSigString.subString(start:0, length: xlength), radix: 16)!,
            BigInt(newSigString.subString(start: xlength+4), radix: 16)!,
        ]

        let p = ABI.Element.ParameterType.uint(bits: 256)
        if let data = ABIEncoder.encode(types: [p, p], values: arr as [AnyObject]) {
            return data
        }
        
        return nil
    }
    
    static func createSignature(_ privateKey: SecKey, algorithm: SecKeyAlgorithm = .ecdsaSignatureDigestX962SHA256, hashData: Data) -> Data? {
        var error: Unmanaged<CFError>?
        let signature = SecKeyCreateSignature(privateKey, algorithm,
                                              hashData as CFData,
                                          &error) as Data?
        return signature
    }
}

extension MFKeychainHelper {
    public static func getPubKey(_ privateKey: SecKey) -> String? {
        guard let publicKey = SecKeyCopyPublicKey(privateKey) else {
            // Can't get public key
            return nil
        }
        var error: Unmanaged<CFError>?
        if let keyData = SecKeyCopyExternalRepresentation(publicKey, &error) as Data? {
            return keyData.hexEncodedString()
        } else {
            return nil
        }
    }
    
    public static func compressedPubKey(_ publicKey: String) -> String {
        return "0x" + publicKey.subString(start: 2)
    }
    
}

