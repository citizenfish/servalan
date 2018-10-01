
import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 2.3
import QtLocation 5.9
import QtPositioning 5.6

ApplicationWindow {
    id: appWindow
    width: 1512
    height: 1512
    visible: true
    property variant gpxPoints: []
    property variant undoHistory: []
    property variant mapMode:{'gpxMode': 'edit', 'gpxRoute' : null, 'gpxNextRouteID' : 0}

    signal open();
    signal newF();
    signal save();
    signal quit();

    Component.onCompleted: {
        appWindow.newF.connect(newFile);
        appWindow.open.connect(openFile);
        appWindow.save.connect(saveFile);
        appWindow.quit.connect(quitApp);
    }

    menuBar: MenuBar {
        Menu {
            title: qsTr("&File")
            Action {
                text: qsTr("&New")
                onTriggered: appWindow.newF();
            }
            Action {
                text: qsTr("&Open")
                onTriggered: appWindow.open();
            }
            Action {
                text: qsTr("&Save")
                onTriggered: appWindow.save();
            }
            MenuSeparator{}
            Action {
                text: qsTr("&Quit")
                 onTriggered: appWindow.quit();
            }
        }
        Menu {
            title: qsTr("&Help")
            Action { text: qsTr("Help")}
            Action { text: qsTr("&About")}

        }
    }

    Plugin {
        id: mapPlugin
        name: "osm"
         PluginParameter {
             name:"osm.mapping.custom.host"
            value:"file:///Users/daveb/Desktop/mapping-data/1-50k/tiles/"
         }
    }

    function newFile() {
        console.log('NEW GPX');
    }
    function openFile() {
        console.log('OPEN GPX');
    }

    function saveFile() {
        console.log('SAVE GPX');
    }

    function quitApp() {
        Qt.quit();
    }

    Map {
        id: baseMap
        anchors.fill: parent
        plugin: mapPlugin
        center: QtPositioning.coordinate(51.072, -1.81) // Salisbury
        zoomLevel: 14

        //Sent by markers when their position changes
        signal renderRoutes(int id);
        signal removeMarkers(int id, int index);

        Component.onCompleted: {
                  /*  for( var i_type in supportedMapTypes ) {
                        if( supportedMapTypes[i_type].name.localeCompare( "Custom URL Map" ) === 0 ) {
                            activeMapType = supportedMapTypes[i_type]
                        }
                    }*/

                    baseMap.renderRoutes.connect(renderRoute);
                    baseMap.removeMarkers.connect(removeMarker)
        }


        MouseArea {
            anchors.fill: parent
            onClicked: mapClicked(mouseX,mouseY)
        }


        //Tell the currently active route to render itself
        function renderRoute(id){
            mapMode.gpxRoute.render(id);
        }

        //Remove items from an active route
        function removeMarker(id, index) {
            mapMode.gpxRoute.remove_marker(id,index);
        }


    }


    function mapClicked(x,y) {

        /* We are editing a gpx file */
        if(mapMode.gpxMode ==='edit' ) {
            /* Add our  marker for this GPX to the map */
            var gpxRoute;
            var gpxMarker = Qt.createComponent("qrc:/gpxMarker.qml").createObject();
            gpxMarker.position = baseMap.toCoordinate(Qt.point(x,y));

            /* If route did not exist then create it */
            if(mapMode.gpxRoute === null) {
                /* Now create a new route and add the marker to it */
                gpxRoute = Qt.createComponent("qrc:/gpxRoute.qml").createObject();
                gpxRoute.gpxRouteID = mapMode.gpxNextRouteID++;
                baseMap.addMapItemGroup(gpxRoute);
                mapMode.gpxRoute = gpxRoute;
            } else {
                gpxRoute = mapMode.gpxRoute;
            }

            /* add the marker to the active route and then cause it to render */

            gpxMarker.gpxRouteID = gpxRoute.gpxRouteID; //tie our marker to its route

            /* calculate an index */
            gpxMarker.markerIndex = gpxRoute.markers.length;
            gpxRoute.markers.push(gpxMarker);
            mapMode.gpxRoute.render(gpxMarker.gpxRouteID);
            baseMap.addMapItem(gpxMarker); //render marker last to stay on top
        }

    }

}
