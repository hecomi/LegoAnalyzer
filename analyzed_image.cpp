#include "analyzed_image.h"
#include <QImage>
#include <QPainter>

namespace MontBlanc
{


AnalyzedImage::AnalyzedImage(QQuickItem *parent)
    : MontBlanc::Image(parent)
{
}


void AnalyzedImage::analyze(const QVariant& var)
{
    image_ = var.value<cv::Mat>();
    if (image_.empty()) {
        emit analyzed(false);
        return;
    }

    // RGB -> GRAY
    cv::cvtColor(image_, image_, CV_BGR2GRAY);
    cv::medianBlur(image_, image_, 51);

    // GRAY -> ARGB
    cv::cvtColor(image_, image_, CV_GRAY2BGRA);
    std::vector<cv::Mat> bgra;
    cv::split(image_, bgra);
    std::swap(bgra[0], bgra[3]);
    std::swap(bgra[1], bgra[2]);

    emit analyzed(true);
    update();
}


}
