#include "analyzed_image.h"
#include <QImage>
#include <QPainter>
#include <algorithm>

namespace MontBlanc
{


AnalyzedImage::AnalyzedImage(QQuickItem *parent)
    : MontBlanc::Image(parent), blur_(0),
      numX_(20), numY_(20),
      targetX_(200), targetY_(10), targetWidth_(300), targetHeight_(300),
      exceptX_(100), exceptY_(100), exceptWidth_(200), exceptHeight_(100)
{
}


void AnalyzedImage::applyEffects(const QVariant& var)
{
    auto image = var.value<cv::Mat>();
    if (image.empty()) {
        emit applied(false);
        return;
    }

    // BGR -> GRAY
    cv::cvtColor(image, image, CV_BGR2GRAY);

    // Blur
    cv::medianBlur(image, image, (blur_ % 2 == 1) ? blur_ : blur_ + 1);

    // draw except area as black
    // cv::rectangle(image, cv::Point(exceptX_, exceptY_), cv::Point(exceptWidth_, exceptHeight_), cv::Scalar(0, 0, 0));

    // GRAY -> ARGB
    cv::cvtColor(image, image, CV_GRAY2BGRA);
    std::vector<cv::Mat> bgra;
    cv::split(image, bgra);
    std::swap(bgra[0], bgra[3]);
    std::swap(bgra[1], bgra[2]);

    image_ = image;
    emit srcChanged();
    emit aspectChanged();
    emit imageWidthChanged();
    emit imageHeightChanged();

    emit applied(true);
    update();
}


QVariantList AnalyzedImage::analyze(const QVariant& var)
{
    QVariantList result;
    auto image = var.value<cv::Mat>();
    if (image.empty()) {
        emit analyzed(false, "Image has not been set yet.");
        return result;
    }

    // BGR -> GRAY
    cv::cvtColor(image, image, CV_BGR2GRAY);

    // Analyze ROI
    if (numX_ < 0 || numY_ < 0) {
        emit analyzed(false, "ROI has not set been yet.");
        return result;
    }
    if (targetX_ <= 0 || targetY_ <= 0) {
        emit analyzed(false, "ROI x/y is invalid.");
        return result;
    }
    if (targetWidth_ <= 0 || targetHeight_ <= 0) {
        emit analyzed(false, "ROI width/height has not set been yet.");
        return result;
    }

    const double roiWidth  = static_cast<double>(targetWidth_)  / numX_;
    const double roiHeight = static_cast<double>(targetHeight_) / numY_;

    for (int i = 0; i < numX_; ++i) {
        QVariantList resultY;
        for (int j = 0; j < numY_; ++j) {
            const double roiX = targetX_ + roiWidth * i;
            const double roiY = targetY_ + roiHeight * j;

            if (roiX + roiWidth  > image.size().width ||
                roiY + roiHeight > image.size().height) {
                emit analyzed(false, "ROI is over image size");
                return result;
            }

            cv::Mat roiImage = image(cv::Rect(roiX, roiY, roiWidth + 1, roiHeight + 1));
            cv::Mat rowAverage, average;
            cv::reduce(roiImage, rowAverage, 0, CV_REDUCE_AVG);
            cv::reduce(rowAverage, average, 1, CV_REDUCE_AVG);

            // Set pixels in ROI as its average color
            for (auto it = roiImage.begin<unsigned char>(); it != roiImage.end<unsigned char>(); ++it) {
                *it = average.at<unsigned char>(0);
            }

            // Pack result
            resultY << average.at<unsigned char>(0);
        }
        result.insert(i, resultY);
    }

    // GRAY -> BGRA -> ARGB
    cv::cvtColor(image, image, CV_GRAY2BGRA);
    std::vector<cv::Mat> bgra;
    cv::split(image, bgra);
    std::swap(bgra[0], bgra[3]);
    std::swap(bgra[1], bgra[2]);

    image_ = image;
    emit srcChanged();
    emit aspectChanged();
    emit imageWidthChanged();
    emit imageHeightChanged();

    emit analyzed(true);
    update();

    return result;
}


}
