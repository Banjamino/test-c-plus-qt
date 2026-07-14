// FIXTURE: trips qmllint --strict. Copy into qml/ on a throwaway branch.
import QtQuick

Item {
    // references an undefined id and a non-existent property
    width: nonExistentItem.width
    property int x: undefinedProperty

    Rectangle {
        colour: "red"     // misspelled property (should be 'color')
    }
}
