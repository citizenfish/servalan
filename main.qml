
import QtQuick 2.0
import QtQuick.Window 2.0
import QtLocation 5.6
import QtPositioning 5.6

Window {
    width: 1512
    height: 1512
    visible: true
    property variant gpxPoints: []
    property variant undoHistory: []

    Plugin {
        id: mapPlugin
        name: "osm"
         PluginParameter {
             name:"osm.mapping.custom.host"
            value:"file:///Users/daveb/Desktop/mapping-data/1-50k/tiles/"
         }
    }

    Map {
        id: baseMap
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(51.072, -1.81) // Salisbury
        zoomLevel: 14
        Component.onCompleted: {
                    for( var i_type in supportedMapTypes ) {
                        if( supportedMapTypes[i_type].name.localeCompare( "Custom URL Map" ) === 0 ) {
                            activeMapType = supportedMapTypes[i_type]
                        }
                    }
                }
       MouseArea {
           anchors.fill: parent
           onClicked: add_marker_to_map(mouseX,mouseY)
       }

       MapPolyline {
           id: gpxLine
           line.width: 10
           line.color:'#F7FA42FF'
           path: []
           MouseArea {
               anchors.fill: parent
               onEntered:  add_marker_to_line(gpxLine,mouseX,mouseY)
           }
       }
    }

    function add_marker_to_map(mouseX,mouseY) {

        var circle = make_circle(mouseX,mouseY);
        baseMap.addMapItem(circle);
        gpxPoints.push(circle);
        polyline_draw();
    }

    function make_circle(x,y) {
        var coordinate = baseMap.toCoordinate(Qt.point(x,y))
        var circle = Qt.createQmlObject('import QtQuick 2.0;import QtLocation 5.6; MapCircle{ id:circle0;MouseArea{anchors.fill: parent;drag.target:parent; onPositionChanged:polyline_draw(); onDoubleClicked:marker_double_clicked(circle0)}}',baseMap);
        circle.radius = 40;
        circle.color = '#800000FF';
        circle.center = coordinate;
        return circle;
    }

    function polyline_draw() {
        var path =[];
        for(var i=0; i < gpxPoints.length; i++){
            path.push(gpxPoints[i].center);
        }

        undoHistory.push(gpxLine.path); //store previous so we can undo if necessary
        gpxLine.path = path;
    }

    function marker_double_clicked(id) {
        // Remove a marker from the line when it is double clicked.
        baseMap.removeMapItem(id);
        var new_gpxPoints = [];
        for(var i=0; i < gpxPoints.length; i++){
            if(gpxPoints[i].x !== id.x && gpxPoints[y] !== id.y) {
                new_gpxPoints.push(gpxPoints[i]);
            }
        }
        gpxPoints = new_gpxPoints;
        polyline_draw();

    }

    function add_marker_to_line(id,x0,y0) {
        var distance = 10000000, index = -1,x1y1,x2y2;
        /* Note well we need to convert all co-ordinates into the map co-ord system using mapToItem */
        var x0t = x0; //because we modify x0 so do not want modified value to change y0
            x0 = id.mapToItem(baseMap,x0,y0).x;
            y0 = id.mapToItem(baseMap,x0t,y0).y;

        for(var i=0; i < gpxLine.path.length - 1; i++){
            //Convert into the map co-ordinate space
            x1y1 = baseMap.fromCoordinate(gpxLine.path[i]);
            x2y2 = baseMap.fromCoordinate(gpxLine.path[i+1]);
            //Use distance from line alogorithm to find the closest line
            var dx =Math.abs( (((x2y2.y - x1y1.y) * x0) -((x2y2.x - x1y1.x) *y0) + (x2y2.x * x1y1.y) - (x2y2.y * x1y1.x)) ) / Math.sqrt(((x2y2.y -x1y1.y)*(x2y2.y -x1y1.y)) +((x2y2.x -x1y1.x) *(x2y2.x -x1y1.x)));
            if(dx < distance) {
                distance = dx;
                index = i;
            }

        }

        //Insert a new point into the gpxPoints array and redraw the line
        if(index >= 0) {
            var circle = make_circle(x0,y0);
             baseMap.addMapItem(circle);
            gpxPoints.splice(index + 1, 0, circle);
            polyline_draw();
        }
    }
}
