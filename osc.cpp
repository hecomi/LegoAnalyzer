#include "osc.h"
#include "osc/OscOutboundPacketStream.h"


namespace {
    const size_t OUTPUT_BUFFER_SIZE = 8192;
}


namespace MontBlanc
{


OSCSender::OSCSender(QObject *parent) :
    QObject(parent), ip_("127.0.0.1"), port_(3333),
    socket_(IpEndpointName(ip_.c_str(), port_))
{
}


void OSCSender::setIp(const QString &ip)
{
    try {
        ip_ = ip.toStdString();
        socket_ .Connect(IpEndpointName(ip_.c_str(), port_));
        emit ipChanged();
    } catch (const std::exception& e) {
        emit error(e.what());
    }
}


QString OSCSender::getIp() const
{
    return ip_.c_str();
}

void OSCSender::setPort(int port)
{
    try {
        port_ = port;
        socket_.Connect(IpEndpointName(ip_.c_str(), port_));
        emit portChanged();
    } catch (const std::exception& e) {
        emit error(e.what());
    }
}


int OSCSender::getPort() const
{
    return port_;
}


void OSCSender::send(const QString &address, const QString& msg)
{
    char buffer[OUTPUT_BUFFER_SIZE];
    osc::OutboundPacketStream p( buffer, OUTPUT_BUFFER_SIZE );

    p << osc::BeginMessage(address.toStdString().c_str())
      << msg.toStdString().c_str()
      << osc::EndMessage;

    socket_.Send(p.Data(), p.Size());
}


void OSCSender::send(const QString &address, int x, int y)
{
    char buffer[OUTPUT_BUFFER_SIZE];
    osc::OutboundPacketStream p( buffer, OUTPUT_BUFFER_SIZE );

    p << osc::BeginMessage(address.toStdString().c_str())
      << x << y
      << osc::EndMessage;

    socket_.Send(p.Data(), p.Size());
}


}
