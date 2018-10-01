#include "gpxfileio_plugin.h"
#include "gpxfileio.h"

#include <qqml.h>

void GpxFileIOPlugin::registerTypes(const char *uri)
{
    // @uri com.citizenfish.qmlcomponents
    qmlRegisterType<GPXFileIO>(uri, 1, 0, "GPXFileIO");
}

