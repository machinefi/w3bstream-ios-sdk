import Foundation

extension String {

    func indexOf(key: String) -> Int {
        guard self.contains(key) else {
            return -1
        }
        guard let range: Range<String.Index> = self.range(of: key) else {
            return -1
        }
        let index = self.distance(from: startIndex, to: range.lowerBound)
        return index
    }

    func subString(start: Int, length: Int = -1) -> String {
         var len = length
         if len == -1 {
             len = self.count - start
         }
         let st = self.index(startIndex, offsetBy: start)
         let en = self.index(st, offsetBy: len)
         return String(self[st ..< en])
     }
    
    func stripHexPrefix() -> String {
        if self.hasPrefix("0x") {
            let indexStart = self.index(self.startIndex, offsetBy: 2)
            return String(self[indexStart...])
        }
        return self
    }
    
    func hasHexPrefix() -> Bool {
        return self.hasPrefix("0x")
    }
    
    func addHexPrefix() -> String {
        if !self.hasPrefix("0x") {
            return "0x" + self
        }
        return self
    }
    
    var fullRange: Range<Index> {
        return startIndex..<endIndex
    }
    
    var fullNSRange: NSRange {
        return NSRange(fullRange, in: self)
    }
}
