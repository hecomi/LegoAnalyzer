import QtQuick 2.1
import QtQuick.LocalStorage 2.0

Item {
    property string name: 'default'
    property string version: '1.0'
    property string description: 'none'
    property int estimatedSize: 100000

    function getDatabase() {
        return LocalStorage.openDatabaseSync(name, version, description, estimatedSize);
    }

    function initialize() {
        var db = getDatabase();
        db.transaction(function(tx) {
            tx.executeSql('CREATE TABLE IF NOT EXISTS settings(key TEXT UNIQUE, value TEXT)');
        });
    }

    function set(key, value) {
        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('INSERT OR REPLACE INTO settings VALUES (?,?);', [key, value]);
            if (rs.rowsAffected > 0) {
                res = "OK";
            } else {
                res = "Error";
            }
        });
        return res;
    }

    function get(key) {
        var db = getDatabase();
        var res = "";
        db.transaction(function(tx) {
            var rs = tx.executeSql('SELECT value FROM settings WHERE key=?;', [key]);
            if (rs.rows.length > 0) {
                res = rs.rows.item(0).value;
            } else {
                res = undefined;
            }
        });
        return res;
    }
}
