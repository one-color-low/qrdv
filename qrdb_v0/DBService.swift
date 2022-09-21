import Foundation
import SQLite3

final class DBService {
    static let shared = DBService()
    
    private let dbFile = "DBVer1.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        if !createTable() {
            print("Failed to create table")
        }
        
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            return nil
        }
        else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() -> Bool {
        let createSql = """
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER NOT NULL PRIMARY KEY,
            name TEXT NOT NULL,
            address TEXT NULL,
            phone_number TEXT NULL,
            created TIMESTAMP DEFAULT (datetime(CURRENT_TIMESTAMP,'localtime'))
        );
        """
        
        let documentDirPath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        print("Simulator location \(documentDirPath)")
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(createStmt)
            return false
        }
        
        sqlite3_finalize(createStmt)
        return true
    }
    
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    func insertUser(user: User) -> Bool {
        let insertSql = """
                        INSERT INTO users
                            (id, name, address, phone_number)
                            VALUES
                            (?, ?, ?, ?);
                        """;
        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_int(insertStmt, 1,Int32(user.id))
        sqlite3_bind_text(insertStmt, 2, (user.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 3, (user.address as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 4, (user.phone_number as NSString).utf8String, -1, nil)
        //sqlite3_bind_text(insertStmt, 5, (user.birth_date as NSString).utf8String, -1, nil)
        
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    func updateUser(user: User) -> Bool {
        let updateSql = """
        UPDATE  users
        SET     name = ?,
                address = ?,
                phone_number = ?
        WHERE   id = ?
        """
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(updateStmt, 1, (user.name as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 2, (user.address as NSString).utf8String, -1, nil)
        sqlite3_bind_text(updateStmt, 3, (user.phone_number as NSString).utf8String, -1, nil)
        
        sqlite3_bind_int(updateStmt, 4, Int32(user.id))
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(updateStmt)
            return false
        }
        sqlite3_finalize(updateStmt)
        return true
    }
    
    func getUser(id: Int) -> (success: Bool, errorMessage: String?, user: User?) {
     
        var user: User? = nil
        
        let sql = """
            SELECT  id, name, address, phone_number
            FROM    users
            WHERE   id = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", user)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(id))
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let id = Int(sqlite3_column_int(stmt, 0))
            let name = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let address = String(describing: String(cString: sqlite3_column_text(stmt, 2)))
            let phone_number = String(describing: String(cString: sqlite3_column_text(stmt, 3)))
            
            user = User(id: id, name: name,
                                address: address, phone_number: phone_number)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, user)
    }
    
}
