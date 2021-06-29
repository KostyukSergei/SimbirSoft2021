#ifndef CONNECTOR_H
#define CONNECTOR_H

#include <QObject>
#include <QDateTime>
#include <QJsonObject>

class Connector : public QObject
{
    Q_OBJECT
public:   
    explicit Connector(QObject *parent = nullptr);
    QJsonObject jsonObj;

signals:
    void toLabel(QString date);
    void toDate(QString date);
    void toEvents(QJsonObject obj);
    void toEvent(QJsonObject obj);

public slots:
    void fromCalendar(QDateTime date);
    void loadJSON(QString date);
    void addJSON(QString name, QString dateStart, QString dateFinish, QString description, QString id);
    void selectEvent(QString id);
    void deleteEvent(QString id);
};

#endif // CONNECTOR_H
