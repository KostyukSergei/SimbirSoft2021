#include "connector.h"
#include <QFile>
#include <QDir>
#include <QLocale>
#include <QJsonArray>
#include <QJsonDocument>

Connector::Connector(QObject *parent) : QObject(parent)
{
}

void Connector::loadJSON(QString dateStr)
{
    QString fileName = "saveData.json";
    QFile jsonFile(fileName);
    jsonFile.open(QIODevice::ReadOnly);
    QByteArray loadData = jsonFile.readAll();
    QJsonDocument jsonDoc(QJsonDocument::fromJson(loadData));
    jsonObj = jsonDoc.object();
    QJsonArray jsonArr = jsonObj["list"].toArray();

    dateStr.truncate(11);
    QDateTime dayStart = QDateTime::fromString(dateStr + "00:00", "dd-MM-yyyy hh:mm");
    QDateTime dayFinish = QDateTime::fromString(dateStr + "23:59", "dd-MM-yyyy hh:mm");
    for(auto it = jsonArr.begin(); it != jsonArr.end();)
    {
        if(dayStart > QDateTime::fromString((*it).toObject()["date_finish"].toString(), "dd-MM-yyyy hh:mm") ||
                dayFinish < QDateTime::fromString((*it).toObject()["date_start"].toString(), "dd-MM-yyyy hh:mm"))
            it = jsonArr.erase(it);
        else
            it++;
    }
    QDateTime tempStart;
    for(int i = 1; i < jsonArr.size(); i++)
    {
        tempStart = QDateTime::fromString(jsonArr[i].toObject()["date_start"].toString(), "dd-MM-yyyy hh:mm");
        for(int j = 0; j < i; j++)
            if(tempStart < QDateTime::fromString(jsonArr[j].toObject()["date_start"].toString(), "dd-MM-yyyy hh:mm"))
            {
                jsonArr.insert(j, jsonArr[i]);
                jsonArr.removeAt(i + 1);
                break;
            }
    }
    for(auto it = jsonArr.begin(); it != jsonArr.end(); it++)
        emit toEvents((*it).toObject());
}

void Connector::fromCalendar(QDateTime date)
{
    QLocale locale(QLocale("ru_RU"));
    QString dateStr = date.toString("dd-MM-yyyy hh:mm");
    QString temp = dateStr;
    emit toDate(dateStr);
    dateStr = locale.toString(date);
    dateStr.truncate(dateStr.lastIndexOf('.') - 2);
    emit toLabel(dateStr);
    loadJSON(temp);
}

void Connector::addJSON(QString name, QString dateStart, QString dateFinish, QString description, QString id)
{
    QJsonObject newObj;
    QJsonArray jsonArr = jsonObj["list"].toArray();
    newObj["name"] = name;
    newObj["date_start"] = dateStart;
    newObj["date_finish"] = dateFinish;
    newObj["description"] = description;
    if(id == NULL)
    {
        newObj["id"] = QString::number(jsonArr.size());
        jsonArr.append(newObj);
    }
    else
        for(auto it = jsonArr.begin(); it != jsonArr.end(); it++)
            if((*it).toObject()["id"] == id)
            {
                newObj["id"] = id;
                (*it) = newObj;
                break;
            }
    jsonObj["list"] = jsonArr;
    QString fileName = "saveData.json";
    QFile jsonFile(fileName);
    jsonFile.open(QIODevice::WriteOnly);
    jsonFile.write(QJsonDocument(jsonObj).toJson(QJsonDocument::Indented));
    jsonFile.close();
}

void Connector::selectEvent(QString id)
{
    QJsonArray jsonArr = jsonObj["list"].toArray();
    for(auto it = jsonArr.begin(); it != jsonArr.end(); it++)
        if((*it).toObject()["id"] == id)
        {
            emit toEvent((*it).toObject());
            return;
        }
}

void Connector::deleteEvent(QString id)
{
    QJsonArray jsonArr = jsonObj["list"].toArray();
    for(int i = 0; i < jsonArr.size(); i++)
        if(jsonArr[i].toObject()["id"] == id)
        {
            jsonArr.removeAt(i);
            QJsonObject temp;
            for(int j = i; j < jsonArr.size(); j++)
            {
                temp = jsonArr[j].toObject();
                temp["id"] = QString::number(j);
                jsonArr[j] = temp;
            }
            break;
        }
    jsonObj["list"] = jsonArr;
    QString fileName = "saveData.json";
    QFile jsonFile(fileName);
    jsonFile.open(QIODevice::WriteOnly);
    jsonFile.write(QJsonDocument(jsonObj).toJson(QJsonDocument::Indented));
    jsonFile.close();
}
