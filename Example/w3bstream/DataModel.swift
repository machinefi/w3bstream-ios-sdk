
import Foundation
import RealmSwift

class DataModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var timestamp: Double = 0
    @objc dynamic var shakeCount: Int = 0
    @objc dynamic var latitude = ""
    @objc dynamic var longitude = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(shakeCount: Int, timestamp: Double, latitude: String, longitude: String) {
        self.init()
        self.id = "\(timestamp)"
        self.shakeCount = shakeCount
        self.timestamp = timestamp
        self.longitude = longitude
        self.latitude = latitude
    }
    
    static func allData() -> [DataModel] {
        do {
            let realm = try Realm()
            let result = realm.objects(DataModel.self).sorted(byKeyPath: "timestamp", ascending: false)
            if result.isEmpty == false {
                return result.toArray()
            }
        }catch let error as NSError {

        }
        return []
    }
    
    func add() {
        do {
            let realm = try Realm()
            try realm.write({
                realm.add(self, update: .all)
            })
        }catch let error as NSError {

        }
    }
}

extension Results {
    func toArray() -> [Element] {
        var arr = [Element]()
        for obj in self.enumerated() {
            arr.append(obj.element)
        }
        return arr
    }
}
