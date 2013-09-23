import QtQuick 2.1
import QtQuick.Controls 1.0

MenuBar {
    Menu {
        title: "Hoge"

        MenuItem {
            text: "Piyo"
            shortcut: "Ctrl+X"
            onTriggered: {}
        }
    }

    Menu {
        title: "Fuga"

        MenuItem {
            text: "Piyo"
            shortcut: "Ctrl+Y"
            onTriggered: {}
        }
    }
}
