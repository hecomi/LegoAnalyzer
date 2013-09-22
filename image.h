#ifndef MONTBLANC_IMAGE_H
#define MONTBLANC_IMAGE_H

#include <QQuickPaintedItem>
#include <QImage>
#include <opencv2/opencv.hpp>

Q_DECLARE_METATYPE(cv::Mat)

namespace MontBlanc
{

class Image : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QVariant image READ image NOTIFY imageChanged)
    Q_PROPERTY(int imageWidth  READ imageWidth NOTIFY imageWidthChanged)
    Q_PROPERTY(int imageHeight READ imageHeight NOTIFY imageHeightChanged)
    Q_PROPERTY(float aspect READ aspect NOTIFY aspectChanged)
    Q_PROPERTY(QString src READ src WRITE setSrc NOTIFY srcChanged)

public:
    explicit Image(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    QVariant image() const;
    int imageWidth() const;
    int imageHeight() const;
    double aspect() const;

    const QString& src() const;
    void setSrc(const QString& src);

signals:
    void imageChanged() const;
    void imageWidthChanged() const;
    void imageHeightChanged() const;
    void srcChanged() const;
    void aspectChanged() const;
    void srcLoaded(bool success) const;

protected:
    QString src_;
    cv::Mat image_;
    double aspect_;
};

}

#endif // AnalyzedImage_H
