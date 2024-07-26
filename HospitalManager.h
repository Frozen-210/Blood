#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>
#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(hospitalManager)

class HospitalManager : public QObject
{
    Q_OBJECT

public:
    explicit HospitalManager(QSqlDatabase& db, QObject *parent = nullptr);

    Q_INVOKABLE bool insertHospital(const QString &name, const QString &email, const QString &password,
                                    const QString &contactNumber, const QString &address, const QString &city,
                                    const QString &state, const QString &country, const QString &zip,
                                    const QString &license);
    Q_INVOKABLE bool hospitalLogin(const QString &email, const QString &password);
    Q_INVOKABLE QVariantMap getHospitalData(const QString &email);
    Q_INVOKABLE bool deleteHospital(const QString &email, const QString &password);
    Q_INVOKABLE bool changeHospitalPassword(const QString &email, const QString &oldPassword, const QString &newPassword);
    Q_INVOKABLE bool updateHospitalProfile(const QString &email, const QVariantMap &hospitalData);
    Q_INVOKABLE QVariantList getHospitalList();
    Q_INVOKABLE QVariantMap getBloodInventoryLevels(const QString &hospitalEmail);

signals:
    void hospitalDeleted(const QString& hospitalEmail);

private:
    QSqlDatabase& m_db;
    QString hashPassword(const QString &password);
};
