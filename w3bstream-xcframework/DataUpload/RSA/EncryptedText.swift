
import Foundation

class EncryptedText {
  // Data to be encrypted
  let data: Data
  private let algo: SecKeyAlgorithm
  
   required init(data: Data, by algo: SecKeyAlgorithm) {
    self.data = data
    self.algo = algo
  }
  
   func decrypted(with key: PrivateKey) throws -> ClearText {
    var error: Unmanaged<CFError>?
    guard let decrypted = SecKeyCreateDecryptedData(key.key, algo, data as CFData, &error) else {
      throw SwiftRSAError.decryptionFailed(error: error?.takeRetainedValue())
    }
    
    return ClearText(data: decrypted as Data)
  }
}

