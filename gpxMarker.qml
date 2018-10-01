import QtQuick 2.0
import QtPositioning 5.8
import QtLocation 5.9



MapCircle{

    property int gpxRouteID: 0
    property int markerIndex:0
    property alias position: circle0.center
    id:circle0
    radius: 50
    color: '#800000FF'
    MouseArea{
        anchors.fill: parent
        drag.target: parent
        onPositionChanged: marker_dragged(circle0)
        onDoubleClicked: marker_double_clicked(circle0)

    }

    function marker_dragged(circle0) {
        //Tell the map to go and render the currently active route.
        parent.renderRoutes(gpxRouteID);

    }

    function marker_double_clicked(circle0) {
        //Remove the marker from route and the map as well
        parent.removeMarkers(gpxRouteID,circle0.markerIndex);
        parent.removeMapItem(circle0);
    }
}

