#include "analyzed_image.h"
#include <QImage>
#include <QPainter>

namespace MontBlanc
{


AnalyzedImage::AnalyzedImage(QQuickItem *parent)
    : MontBlanc::Image(parent), blur_(0)
{
}


void AnalyzedImage::analyze(const QVariant& var)
{
    image_ = var.value<cv::Mat>();
    if (image_.empty()) {
        emit analyzed(false);
        return;
    }

    aspect_ = static_cast<double>(image_.size().width) / image_.size().height;
    emit aspectChanged();

    // RGB -> GRAY
    cv::cvtColor(image_, image_, CV_BGR2GRAY);

    // Blur
    cv::medianBlur(image_, image_, (blur_ % 2 == 1) ? blur_ : blur_ + 1);

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
