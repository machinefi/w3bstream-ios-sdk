import Foundation

public enum SwiftRSAError: Error {
  case emptyPEMKey
  case invalidBase64String
  case algorithmIsNotSupported
  case clearTextTooLong
  case addKeyFailed(error: CFError?)
  case encryptionFailed(error: CFError?)
  case decryptionFailed(error: CFError?)
  case externalRepresentationFailed(error: CFError?)
}
