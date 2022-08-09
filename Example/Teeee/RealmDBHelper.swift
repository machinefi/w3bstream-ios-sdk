import RealmSwift
import UIKit

class RealmDBHelper: NSObject {

    static let RealmDBVersion: UInt64 = 1

    public class func configRealm() {
   
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/defaultDB.realm")
        let config = Realm.Configuration(fileURL: URL(string: dbPath),
                                         schemaVersion: RealmDBVersion,
                                         migrationBlock: { _, _ in

        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        if #available(iOS 13.0, *) {
            Realm.asyncOpen()
        } else {
            // Fallback on earlier versions
        }
    }
}
