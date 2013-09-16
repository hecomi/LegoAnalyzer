#include <QtGui/QGuiApplication>
#include <QQmlEngine>
#include <QQmlContext>
#include <QScopedPointer>
#include "qtquick2applicationviewer.h"
#include "camera_image.h"
#include "analyzed_image.h"

int main(int argc, char *argv[])
{
    // Init
    QGuiApplication app(argc, argv);

    // Create viewer
    QtQuick2ApplicationViewer viewer;

    // Register types
    qmlRegisterType<MontBlanc::CameraImage>("OpenCV", 1, 0, "Camera");
    qmlRegisterType<MontBlanc::AnalyzedImage>("OpenCV", 1, 0, "AnalyzedImage");

    // Show QML
    viewer.setMainQmlFile(QStringLiteral("qml/LegoAnalyzer/main.qml"));
    viewer.showExpanded();

    // Run
    return app.exec();
}
