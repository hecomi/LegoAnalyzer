#ifndef MONTBLANC_ANALYZED_IMAGE_H
#define MONTBLANC_ANALYZED_IMAGE_H

#include "image.h"

namespace MontBlanc
{

class AnalyzedImage : public Image
{
    Q_OBJECT
    Q_PROPERTY(int blur MEMBER blur_ NOTIFY blurChanged)
    Q_PROPERTY(int numX MEMBER numX_)
    Q_PROPERTY(int numY MEMBER numY_)
    Q_PROPERTY(int targetX MEMBER targetX_)
    Q_PROPERTY(int targetY MEMBER targetY_)
    Q_PROPERTY(int targetWidth MEMBER targetWidth_)
    Q_PROPERTY(int targetHeight MEMBER targetHeight_)

public:
    explicit AnalyzedImage(QQuickItem *parent = 0);
    Q_INVOKABLE void applyEffects(const QVariant& var);
    Q_INVOKABLE QVariantList analyze(const QVariant& var);

private:
    /*
    class Gray2ARGBatLeavingScope
    {
        cv::Mat mat_;

    public:
        Gray2ARGBatLeavingScope(const cv::Mat& mat);
        ~Gray2ARGBatLeavingScope();
    };
    */

signals:
    void blurChanged() const;
    void applied(bool success) const;
    void analyzed(bool success, const QString& msg = "") const;

private:
    int blur_;
    int targetX_, targetY_;
    int targetWidth_, targetHeight_;
    int numX_, numY_;
};

}

#endif // AnalyzedImage_H
