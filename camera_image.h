#ifndef MONTBLANC_CAMERA_H
#define MONTBLANC_CAMERA_H

#include "image.h"

namespace MontBlanc
{

class CameraImage : public Image
{
    Q_OBJECT

public:
    CameraImage(QQuickItem *parent = 0);
    void paint(QPainter *painter);

private:
    cv::VideoCapture camera_;
};

}

#endif // CAMERA_H
