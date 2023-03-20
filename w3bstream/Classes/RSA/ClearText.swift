import Foundation

class ClearText {
  // Data to be encrypted
   let data: Data
   var stringValue: String {
    return String(data: data, encoding: .utf8)!
  }
  
   required init(data: Data) {
    self.data = data
  }
  
   required init(string: String) {
    self.data = string.data(using: .utf8)!
  }
  
  /// Encrypt the clear text.
  ///
  /// - parameter `with`:  key used for encryption.
  /// - parameter `by`: The RSA algorithm
  /// - Returns: The encrypted data.
  /// - Throws:
  ///   - `SwiftRSAError.clearTextTooLong` if the clear text is too long.
  ///   - `SwiftRSAError.encryptionFailed` if the encryption is failed.
   func encrypted(with key: PublicKey, by algorithm: SecKeyAlgorithm) throws -> EncryptedText {
    /// 1. Is the `algorithm` supported by the platform
    guard SecKeyIsAlgorithmSupported(key.key, .encrypt, algorithm) else {
      throw SwiftRSAError.algorithmIsNotSupported
    }
    
    /// 2. Is the data short enough to be encrypted
    let maxCount = try ClearText.maxClearTextInLength(key.key, algorithm: algorithm)
    guard data.count <= maxCount else {
      throw SwiftRSAError.clearTextTooLong
    }
    
    /// 3. Make the encryption
    var error: Unmanaged<CFError>?
    guard let encrypted = SecKeyCreateEncryptedData(key.key, algorithm, data as CFData, &error) else {
      throw SwiftRSAError.encryptionFailed(error: error?.takeRetainedValue())
    }
    
    return EncryptedText(data: encrypted as Data, by: algorithm)
  }
    
   func encrypted(with privateKey: PrivateKey, by algorithm: SecKeyAlgorithm) throws -> EncryptedText {
      /// 1. Is the `algorithm` supported by the platform
      guard SecKeyIsAlgorithmSupported(privateKey.key, .encrypt, algorithm) else {
        throw SwiftRSAError.algorithmIsNotSupported
      }
      
      /// 2. Is the data short enough to be encrypted
      let maxCount = try ClearText.maxClearTextInLength(privateKey.key, algorithm: algorithm)
      guard data.count <= maxCount else {
        throw SwiftRSAError.clearTextTooLong
      }
      
      /// 3. Make the encryption
      var error: Unmanaged<CFError>?
      guard let encrypted = SecKeyCreateEncryptedData(privateKey.key, algorithm, data as CFData, &error) else {
        throw SwiftRSAError.encryptionFailed(error: error?.takeRetainedValue())
      }
      
      return EncryptedText(data: encrypted as Data, by: algorithm)
    }
    
  
  /// Get the overhead of each RSA algorithm in bytes in decimal.
  ///
  /// - parameter `of`: RSA algorithm
  /// - returns: The overhead in bytes in decimal
  /// - Throws: `SwiftRSAError.algorithmIsNotSupported` if the algorithm is not supported.
  /// - ToDo: Add PKCS v1.5 and no padding support
  static func _overhead(of algorithm: SecKeyAlgorithm) throws -> Int {
    func fomulaOfOaep(_ lengthInBits: Int) -> Int {
      return 2 * (lengthInBits / 8) + 2
    }
    
    switch algorithm {
    case .rsaEncryptionOAEPSHA1:
      return fomulaOfOaep(160)
    case .rsaEncryptionOAEPSHA224:
      return fomulaOfOaep(224)
    case .rsaEncryptionOAEPSHA256:
      return fomulaOfOaep(256)
    case .rsaEncryptionOAEPSHA384:
      return fomulaOfOaep(384)
    case .rsaEncryptionOAEPSHA512:
      return fomulaOfOaep(512)
    default:
      throw SwiftRSAError.algorithmIsNotSupported
    }
  }
  
   static func maxClearTextInLength(_ key: SecKey, algorithm: SecKeyAlgorithm) throws -> Int {
    let keyLength = SecKeyGetBlockSize(key)
    let overhead = try ClearText._overhead(of: algorithm)
    
    return keyLength - overhead
  }
    
    /// Signs a clear message using a private key.
    /// The clear message will first be hashed using the specified digest type, then signed
    /// using the provided private key.
    ///
    /// - Parameters:
    ///   - key: Private key to sign the clear message with
    ///   - digestType: Digest
    /// - Returns: Signature of the clear message after signing it with the specified digest type.
    /// - Throws: SwiftyRSAError
     func signed(with key: PrivateKey, digestType: Signature.DigestType) throws -> Signature {
        
        let digest = self.digest(digestType: digestType)
        let blockSize = SecKeyGetBlockSize(key.key)
        let maxChunkSize = blockSize - 11
        
        guard digest.count <= maxChunkSize else {
            throw SwiftyRSAError.invalidDigestSize(digestSize: digest.count, maxChunkSize: maxChunkSize)
        }
        
        var digestBytes = [UInt8](repeating: 0, count: digest.count)
        (digest as NSData).getBytes(&digestBytes, length: digest.count)
        
        var signatureBytes = [UInt8](repeating: 0, count: blockSize)
        var signatureDataLength = blockSize
        
        let status = SecKeyRawSign(key.key, digestType.padding, digestBytes, digestBytes.count, &signatureBytes, &signatureDataLength)
        
        guard status == noErr else {
            throw SwiftyRSAError.signatureCreateFailed(status: status)
        }
        
        let signatureData = Data(bytes: signatureBytes, count: signatureBytes.count)
        return Signature(data: signatureData)
    }
    
    /// Verifies the signature of a clear message.
    ///
    /// - Parameters:
    ///   - key:  key to verify the signature with
    ///   - signature: Signature to verify
    ///   - digestType: Digest type used for the signature
    /// - Returns: Result of the verification
    /// - Throws: SwiftyRSAError
     func verify(with key: PrivateKey, signature: Signature, digestType: Signature.DigestType) throws -> Bool {

        let digest = self.digest(digestType: digestType)
        var digestBytes = [UInt8](repeating: 0, count: digest.count)
        (digest as NSData).getBytes(&digestBytes, length: digest.count)

        var signatureBytes = [UInt8](repeating: 0, count: signature.data.count)
        (signature.data as NSData).getBytes(&signatureBytes, length: signature.data.count)

        let status = SecKeyRawVerify(key.key, digestType.padding, digestBytes, digestBytes.count, signatureBytes, signatureBytes.count)

        if status == errSecSuccess {
            return true
        } else if status == -9809 {
            return false
        } else {
            throw SwiftyRSAError.signatureVerifyFailed(status: status)
        }
    }
    
    func digest(digestType: Signature.DigestType) -> Data {
        
        let digest: Data

        switch digestType {
        case .sha1:
            digest = data.sha1()
        case .sha224:
            digest = data.sha224()
        case .sha256:
            digest = data.sha256()
        case .sha384:
            digest = data.sha384()
        case .sha512:
            digest = data.sha512()
        }

        return digest
    }
    
}
