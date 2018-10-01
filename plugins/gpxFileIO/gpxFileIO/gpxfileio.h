#ifndef GPXFILEIO_H
#define GPXFILEIO_H

#include <QQuickItem>

class GPXFileIO : public QQuickItem
{
    Q_OBJECT
    Q_DISABLE_COPY(GPXFileIO)
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)


public:
    GPXFileIO(QQuickItem *parent = nullptr);
    ~GPXFileIO();
    Q_INVOKABLE void read();
    Q_INVOKABLE void write();
};

#endif // GPXFILEIO_H
