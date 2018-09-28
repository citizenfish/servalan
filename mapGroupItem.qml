
import QtQuick 2.0
import QtQuick.Window 2.0
import QtLocation 5.9
import QtPositioning 5.6

Window {
    width: 1512
    height: 1512
    visible: true
    property variant gpxPoints: []
    property variant undoHistory: []
    property variant mapMode:{'gpxMode': 'edit', 'gpxRoute' : null}

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
            onClicked: mapClicked(mouseX,mouseY)
        }


    }

    function mapClicked(x,y) {

        /* We are creating a new gpx file */
        if(mapMode.gpxMode ==='edit' ) {
            /* Add our  marker for this GPX to the map */
            var gpxRoute;
            var gpxMarker = Qt.createComponent("qrc:/gpxMarker.qml").createObject();
            gpxMarker.position = baseMap.toCoordinate(Qt.point(x,y));


            if(mapMode.gpxRoute === null) {
                /* Now create a new route and add the marker to it */
                gpxRoute = Qt.createComponent("qrc:/gpxRoute.qml").createObject();
                baseMap.addMapItemGroup(gpxRoute);
                mapMode.gpxRoute = gpxRoute;
            } else {
                gpxRoute = mapMode.gpxRoute;
            }

            gpxRoute.markers.push(gpxMarker);
            gpxRoute.render();
 baseMap.addMapItem(gpxMarker);
        }

        /* We are adding to an existing gpxFile */
        if(mapMode.gpxMode ==='edit' && mapMode.gpxRoute !== null) {
            var gpxRoute = mapMode.gpxRoute;
            gpxRoute
        }
    }
}
