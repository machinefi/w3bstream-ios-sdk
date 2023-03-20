import Foundation

public class PrivateKey: RSAKey {
  public let key: SecKey
  
  required public init(key: SecKey) {
    self.key = key
  }
  
  /// Initializer of `PrivateKey`
  ///
  /// - parameter data: DER formatted key data.
  /// - throws: `SwiftRSAError.addKeyFailed(error:)` if creation failed.
  /// - ToDo: We should get rid of the X.509 header if the key is a certificate.
  required public init?(der: Data) {
    do {
      self.key = try SwiftRSA.createKey(der, isPublic: false)
    }
    catch {
      return nil
    }
  }
  
  public func pemString() throws -> String {
    let data = try self.data()
    return SwiftRSA.format(der: data, withPemType: "RSA PRIVATE KEY")
  }
}

