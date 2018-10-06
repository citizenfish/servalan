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
    QUrl source() const;
       QString text() const;
   public slots:
       void setSource(QUrl source);
       void setText(QString text);
   signals:
       void sourceChanged(QUrl arg);
       void textChanged(QString arg);
   private:
       QUrl m_source;
       QString m_text;
};

#endif // GPXFILEIO_H
