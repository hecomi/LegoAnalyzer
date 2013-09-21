#include "analyzed_image.h"
#include <QImage>
#include <QPainter>
#include <algorithm>

namespace MontBlanc
{


AnalyzedImage::AnalyzedImage(QQuickItem *parent)
    : MontBlanc::Image(parent), blur_(0),
      numX_(20), numY_(20),
      targetX_(200), targetY_(10), targetWidth_(300), targetHeight_(300)
{
}


void AnalyzedImage::applyEffects(const QVariant& var)
{
    image_ = var.value<cv::Mat>();
    if (image_.empty()) {
        emit applied(false);
        return;
    }

    // BGR -> GRAY
    cv::cvtColor(image_, image_, CV_BGR2GRAY);

    // Blur
    cv::medianBlur(image_, image_, (blur_ % 2 == 1) ? blur_ : blur_ + 1);

    // GRAY -> ARGB
    cv::cvtColor(image_, image_, CV_GRAY2BGRA);
    std::vector<cv::Mat> bgra;
    cv::split(image_, bgra);
    std::swap(bgra[0], bgra[3]);
    std::swap(bgra[1], bgra[2]);

    emit applied(true);
    update();
}


void AnalyzedImage::analyze(const QVariant& var)
{
    image_ = var.value<cv::Mat>();
    if (image_.empty()) {
        emit analyzed(false, "Image has not been set yet.");
        return;
    }

    // BGR -> GRAY
    cv::cvtColor(image_, image_, CV_BGR2GRAY);

    // Analyze ROI
    if (numX_ <= 0 || numY_ <= 0) {
        emit analyzed(false, "ROI has not set been yet.");
        return;
    }
    if (targetX_ <= 0 || targetY_ <= 0) {
        emit analyzed(false, "ROI x/y is invalid.");
        return;
    }
    if (targetWidth_ <= 0 || targetHeight_ <= 0) {
        emit analyzed(false, "ROI width/height has not set been yet.");
        return;
    }

    const int roiWidth  = targetWidth_  / numX_;
    const int roiHeight = targetHeight_ / numY_;

    for (int i = 0; i < numX_; ++i) {
        for (int j = 0; j < numY_; ++j) {
            const int roiX = targetX_ + roiWidth * i;
            const int roiY = targetY_ + roiHeight * j;

            if (roiX + roiWidth  > image_.size().width ||
                roiY + roiHeight > image_.size().height) {
                emit analyzed(false, "ROI is over image size");
                return;
            }

            cv::Mat roiImage = image_(cv::Rect(roiX, roiY, roiWidth, roiHeight));
            cv::Mat rowAverage, average;
            cv::reduce(roiImage, rowAverage, 0, CV_REDUCE_AVG);
            cv::reduce(rowAverage, average, 1, CV_REDUCE_AVG);

            // Set pixels in ROI as its average color
            for (auto it = roiImage.begin<unsigned char>(); it != roiImage.end<unsigned char>(); ++it) {
                *it = average.at<unsigned char>(0);
            }
        }
    }

    // GRAY -> BGRA -> ARGB
    cv::cvtColor(image_, image_, CV_GRAY2BGRA);
    std::vector<cv::Mat> bgra;
    cv::split(image_, bgra);
    std::swap(bgra[0], bgra[3]);
    std::swap(bgra[1], bgra[2]);

    emit analyzed(true);
    update();
}


}
