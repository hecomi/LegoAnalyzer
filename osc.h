#ifndef OSC_H
#define OSC_H

#include <QObject>
#include <QString>
#include "osc/OscOutboundPacketStream.h"
#include "ip/UdpSocket.h"

namespace MontBlanc
{

class OSCSender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ip READ getIp WRITE setIp NOTIFY ipChanged)
    Q_PROPERTY(int port READ getPort WRITE setPort NOTIFY portChanged)

public:
    explicit OSCSender(QObject *parent = 0);
    Q_INVOKABLE void send(const QString& address, int x, int y);
    Q_INVOKABLE void send(const QString& address, const QString& msg);
    QString getIp() const;
    void setIp(const QString& ip);
    int getPort() const;
    void setPort(int port);

signals:
    void error(const QString& msg);
    void ipChanged();
    void portChanged();

private:
    std::string ip_;
    int port_;
    UdpTransmitSocket socket_;
};


}

#endif // OSC_H
