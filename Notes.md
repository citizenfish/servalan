#Notes

Use the minimal map example to build out from

This uses plugins to display the map

Source code for OSM plugin is here http://code.qt.io/cgit/qt/qtlocation.git/tree/src/plugins/geoservices/osm


#TODO

1) Make a local zxy tileset from OS 1:25K and 1:50k data

a) make huge virtual raster of 1:50k mapping

-download georeferencing tiles from https://www.ordnancesurvey.co.uk/business-and-government/help-and-support/products/georeferencing-files-land-sea-tiles.html

```
mkdir all-tiles
cd data
find . -name *.tif -exec mv {} ../all-tiles/ \;
cd 50krastertab
mv *.TAB ../all-tiles

find . -name *.tif -print > file-list.txt

gdalbuildvrt -input_file_list file-list.txt os_50k.vrt

gdal_translate -of vrt -expand rgba os_50k.vrt temp.vrt
```

Now then, gdal2tiles.py creates tiles with the TMS specification. Openstreetmap uses XYZ spec which needs a modified version of gdal2tiles.py in order to create these.
```
git clone https://github.com/pramsey/gdal2tilesp.git
cp gdal2tilesp.py /usr/local/bin

gdal2tileps.py -z 14 --profile=mercator -s EPSG:27700 temp.vrt tiles/
 
```

#Point on line

https://stackoverflow.com/questions/31346862/test-if-a-point-is-approximately-on-a-line-segment-formed-by-two-other-points
