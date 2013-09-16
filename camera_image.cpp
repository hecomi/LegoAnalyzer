#include "camera_image.h"
#include <QPainter>

namespace MontBlanc
{


CameraImage::CameraImage(QQuickItem *parent)
    : Image(parent), camera_(0)
{

}


void CameraImage::paint(QPainter *painter)
{
    // get camera input
    camera_ >> image_;
    emit imageChanged();

    Image::paint(painter);
}


}
