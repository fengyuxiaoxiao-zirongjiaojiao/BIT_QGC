import QtQuick 2.4

Item {
    width: 400
    height: 400

    Image {
        id: image
        x: 31
        y: 69
        width: 339
        height: 260
        source: "qrc:/qtquickplugin/images/template_image.png"
        fillMode: Image.PreserveAspectFit

        MouseArea {
            id: mouseArea
            x: 53
            y: 29
            width: 256
            height: 192
        }
    }
}
