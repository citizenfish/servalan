import QtQuick 2.0
import QtPositioning 5.8
import QtLocation 5.9

MapItemGroup {
    id: gpxRoute1
    property variant markers: []
    property variant undo_history: []
    property int gpxRouteID: 0


    MapPolyline {
        id: gpxLine
        line.width: 10
        line.color:'#F7FA42FF'
        path: []
        MouseArea {
            anchors.fill: parent
            onEntered:  add_marker(gpxLine,mouseX,mouseY)
        }
    }

    function add_marker(id,x0,y0) {
        var distance = 10000000, index = -1,x1y1,x2y2;
        /* Note well we need to convert all co-ordinates into the map co-ord system using mapToItem */
        var x0t = x0; //because we modify x0 so do not want modified value to change y0
            x0 = id.mapToItem(parent,x0,y0).x;
            y0 = id.mapToItem(parent,x0t,y0).y;

        for(var i=0; i < gpxLine.path.length - 1; i++){
            //Convert into the map co-ordinate space
            x1y1 = parent.fromCoordinate(gpxLine.path[i]);
            x2y2 = parent.fromCoordinate(gpxLine.path[i+1]);
            //Use distance from line alogorithm to find the closest line
            var dx =Math.abs( (((x2y2.y - x1y1.y) * x0) -((x2y2.x - x1y1.x) *y0) + (x2y2.x * x1y1.y) - (x2y2.y * x1y1.x)) ) / Math.sqrt(((x2y2.y -x1y1.y)*(x2y2.y -x1y1.y)) +((x2y2.x -x1y1.x) *(x2y2.x -x1y1.x)));
            if(dx < distance) {
                distance = dx;
                index = i;
            }

        }

        //Insert a new point into the gpxPoints array and redraw the line
        if(index >= 0) {
             var gpxMarker = Qt.createComponent("qrc:/gpxMarker.qml").createObject();
             gpxMarker.position = parent.toCoordinate(Qt.point(x0,y0));
             parent.addMapItem(gpxMarker);
             gpxRoute1.markers.splice(index + 1, 0, gpxMarker);
             for(var f = index + 1; f < gpxRoute1.markers.length; f++) {
                 gpxRoute1.markers[f].markerIndex++;
             }

             gpxRoute1.render();
        }
    }

   function remove_marker(routeID, index) {
       if(routeID !== undefined && routeID !== gpxRouteID) {
           return;
       }

       gpxRoute1.markers.splice(index,1);
       gpxRoute1.render();
   }

   function render(routeID) {
        /* Only render if I am the route concerned */
        if(routeID !== undefined && routeID !== gpxRouteID) {
            return;
        }


        var render_path = [];
        for(var f = 0; f < markers.length; f++) {
            render_path.push(markers[f].center);
        }

        gpxLine.path = render_path;
    }

}
