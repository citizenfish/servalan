#include "gpxfileio.h"

GPXFileIO::GPXFileIO(QQuickItem *parent):
    QQuickItem(parent)
{
    // By default, QQuickItem does not draw anything. If you subclass
    // QQuickItem to create a visual item, you will need to uncomment the
    // following line and re-implement updatePaintNode()

    // setFlag(ItemHasContents, true);
    //make

}

GPXFileIO::~GPXFileIO()
{
}

void GPXFileIO::read(){
    if(m_source.isEmpty()) {
            return;
        }
        QFile file(m_source.toLocalFile());
        if(!file.exists()) {
            qWarning() << "Does not exits: " << m_source.toLocalFile();
            return;
        }
        if(file.open(QIODevice::ReadOnly)) {
            QTextStream stream(&file);
            m_text = stream.readAll();
            emit textChanged(m_text);
        }
}

void GPXFileIO::write() {
    if(m_source.isEmpty()) {
           return;
       }
       QFile file(m_source.toLocalFile());
       if(file.open(QIODevice::WriteOnly)) {
           QTextStream stream(&file);
           stream << m_text;
       }
}

QUrl GPXFileIO::source() const {
    return m_source;
}

QString GPXFileIO::text() const {
    return m_text;
}

void GPXFileIO::setSource(QUrl source)
{
    if (m_source == source)
        return;

    m_source = source;
    emit sourceChanged(source);
}

void GPXFileIO::setText(QString text)
{
    if (m_text == text)
        return;

    m_text = text;
    emit textChanged(text);
}

