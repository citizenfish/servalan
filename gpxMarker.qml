import QtQuick 2.0
import QtPositioning 5.8
import QtLocation 5.9


MapCircle{

    property alias position: circle0.center
    id:circle0
    radius: 50
    color: '#800000FF'
    MouseArea{
        anchors.fill: parent
        drag.target: parent
        /*onPositionChanged: polyline_draw()
        onDoubleClicked: marker_double_clicked(circle0)
        */
    }
}

