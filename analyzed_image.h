#ifndef MONTBLANC_ANALYZED_IMAGE_H
#define MONTBLANC_ANALYZED_IMAGE_H

#include "image.h"

namespace MontBlanc
{

class AnalyzedImage : public Image
{
    Q_OBJECT

public:
    explicit AnalyzedImage(QQuickItem *parent = 0);
    Q_INVOKABLE void analyze(const QVariant& var);

signals:
    void analyzed(bool success);
};

}

#endif // AnalyzedImage_H
