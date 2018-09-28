import QtQuick 2.0
import QtPositioning 5.8
import QtLocation 5.9

MapItemGroup {
    id: gpxRoute1
    property variant markers: []


    MapPolyline {
        id: gpxLine
        line.width: 10
        line.color:'#F7FA42FF'
        path: []
    }

   function render() {
        var render_path = [];
        for(var f = 0; f < markers.length; f++) {
            render_path.push(markers[f].center);
        }

        gpxLine.path = render_path;
    }

}
