#include "image.h"
#include <QPainter>


namespace MontBlanc
{


Image::Image(QQuickItem *parent)
    : QQuickPaintedItem(parent), aspect_(1.0)
{
}


void Image::paint(QPainter *painter)
{
    if (image_.empty()) return;

    // Scaling to QML Element size
    cv::Mat scaled_img(width(), height(), image_.type());
    cv::resize(image_, scaled_img, scaled_img.size(), cv::INTER_CUBIC);

    // BGR -> ARGB
    cv::cvtColor(scaled_img, scaled_img, CV_BGR2BGRA);
    std::vector<cv::Mat> bgra;
    cv::split(scaled_img, bgra);
    std::swap(bgra[0], bgra[3]);
    std::swap(bgra[1], bgra[2]);

    // Paint
    QImage output_img(scaled_img.data, scaled_img.cols, scaled_img.rows, QImage::Format_ARGB32);
    output_img = output_img.scaled(width(), height());
    painter->drawImage(width()/2  - output_img.size().width()/2,
                       height()/2 - output_img.size().height()/2,
                       output_img);
}


const QString& Image::src() const
{
    return src_;
}


void Image::setSrc(const QString& src)
{
    image_ = cv::imread(src.toStdString());

    if (image_.empty()) {
        emit srcLoaded(false);
        return;
    }

    aspect_ = static_cast<double>(image_.size().width) / image_.size().height;

    emit aspectChanged();
    emit srcLoaded(true);
}


QVariant Image::image() const
{
    return QVariant::fromValue(image_);
}


double Image::aspect() const
{
    return aspect_;
}



}
