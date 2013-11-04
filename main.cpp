#include <QtGui/QGuiApplication>
#include <QQmlEngine>
#include "qtquick2applicationviewer.h"
#include "camera_image.h"
#include "analyzed_image.h"
#include "osc.h"


int main(int argc, char *argv[])
{
    // Init
    QGuiApplication app(argc, argv);

    // Create viewer
    QtQuick2ApplicationViewer viewer;

    // Register types
    qmlRegisterType<MontBlanc::Image>("OpenCV", 1, 0, "PlainImage");
    qmlRegisterType<MontBlanc::CameraImage>("OpenCV", 1, 0, "Camera");
    qmlRegisterType<MontBlanc::AnalyzedImage>("OpenCV", 1, 0, "AnalyzedImage");
    qmlRegisterType<MontBlanc::OSCSender>("OSC", 1, 0, "OSCSender");

    // Show QML
    viewer.setMainQmlFile(QStringLiteral("qml/LegoAnalyzer/main.qml"));
    viewer.showExpanded();

    std::cout << viewer.engine()->offlineStoragePath().toStdString() << std::endl;

    // Run
    return app.exec();
}
