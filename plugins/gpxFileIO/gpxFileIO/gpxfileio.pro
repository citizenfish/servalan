TEMPLATE = lib
TARGET = gpxFileIO
QT += qml quick
CONFIG += plugin c++11

TARGET = $$qtLibraryTarget($$TARGET)
uri = com.citizenfish.qmlcomponents

# Input
SOURCES += \
        gpxfileio_plugin.cpp \
        gpxfileio.cpp

HEADERS += \
        gpxfileio_plugin.h \
        gpxfileio.h

DISTFILES = qmldir

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir


#Massive hack to get plugin where it can be found I need to understand this better
osx {
    installPath = '/Users/daveb/Qt5/5.11.1/clang_64/qml/com/citizenfish/qmlcomponents/'
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}
