#ifndef MONTBLANC_CAMERA_H
#define MONTBLANC_CAMERA_H

#include "image.h"

namespace MontBlanc
{

class CameraImage : public Image
{
    Q_OBJECT
    Q_PROPERTY(double fx MEMBER fx_)
    Q_PROPERTY(double fy MEMBER fy_)
    Q_PROPERTY(double cx MEMBER cx_)
    Q_PROPERTY(double cy MEMBER cy_)
    Q_PROPERTY(double k1 MEMBER k1_)
    Q_PROPERTY(double k2 MEMBER k2_)
    Q_PROPERTY(double p1 MEMBER p1_)
    Q_PROPERTY(double p2 MEMBER p2_)
    Q_PROPERTY(bool isUndistorted MEMBER isUndistorted_)

public:
    CameraImage(QQuickItem *parent = 0);
    void paint(QPainter *painter);

private:
    cv::VideoCapture camera_;
    bool isUndistorted_;
    double fx_, fy_, cx_, cy_;
    double k1_, k2_, p1_, p2_;
};

}

#endif // CAMERA_H
