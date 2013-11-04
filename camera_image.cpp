#include "camera_image.h"
#include <QPainter>

namespace MontBlanc
{


CameraImage::CameraImage(QQuickItem *parent)
    : Image(parent), camera_(0),
      isUndistorted_(false), rotation_(0.0), scale_(1.0),
      fx_(1055.50), fy_(1055.93), cx_(576.67), cy_(370.90),
      k1_(-0.429863), k2_(0.206532), p1_(0.002372), p2_(0.002372)
{

}


void CameraImage::paint(QPainter *painter)
{
    // get camera input
    camera_ >> image_;

    // Undistortion
    if (isUndistorted_) {
        cv::Mat undistortedImage;
        cv::Mat cameraMatrix  = (cv::Mat_<double>(3,3) << fx_, 0, cx_, 0, fy_, cy_, 0, 0, 1);
        cv::Mat distCoeffs    = (cv::Mat_<double>(4,1) << k1_, k2_, p1_, p2_);
        cv::undistort(image_, undistortedImage, cameraMatrix, distCoeffs);

        cv::Mat affinedImage;
        cv::Point2f center(undistortedImage.cols*0.5, undistortedImage.rows*0.5);
        const cv::Mat affineMatrix = cv::getRotationMatrix2D(center, rotation_, scale_);
        cv::warpAffine(undistortedImage, affinedImage, affineMatrix, undistortedImage.size());

        image_ = affinedImage;
    }

    emit imageChanged();

    Image::paint(painter);
}


}
