# Add more folders to ship with the application, here
folder_01.source = qml/LegoAnalyzer
folder_01.target = qml
DEPLOYMENTFOLDERS = folder_01

# Additional import path used to resolve QML modules in Creator's code model
QML_IMPORT_PATH =

# If your application uses the Qt Mobility libraries, uncomment the following
# lines and add the respective components to the MOBILITY variable.
# CONFIG += mobility
# MOBILITY +=

# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp \
	image.cpp \
	analyzed_image.cpp \
	camera_image.cpp

# Installation path
# target.path =

# Please do not modify the following two lines. Required for deployment.
include(qtquick2applicationviewer/qtquick2applicationviewer.pri)
qtcAddDeployment()

HEADERS += \
	image.h \
	analyzed_image.h \
	camera_image.h

QMAKE_CFLAGS_WARN_OFF += -Woverloaded-virtual
QMAKE_INCDIR += /usr/local/include
QMAKE_LIBDIR += /usr/local/lib
QMAKE_LIBS   += -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_nonfree -lopencv_features2d

OTHER_FILES += \
	qml/LegoAnalyzer/Camera.qml \
    qml/LegoAnalyzer/MyMenuBar.qml
