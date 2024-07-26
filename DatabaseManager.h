#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>
#include <QLoggingCategory>
#include "UserManager.h"
#include "HospitalManager.h"
#include "DonationManager.h"
#include "AppointmentManager.h"

Q_DECLARE_LOGGING_CATEGORY(dbManager)

class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(QObject *parent = nullptr);
    ~DatabaseManager();

    Q_INVOKABLE bool initialize();
    Q_INVOKABLE void close();

    Q_INVOKABLE UserManager* userManager() const { return m_userManager.get(); }
    Q_INVOKABLE HospitalManager* hospitalManager() const { return m_hospitalManager.get(); }
    Q_INVOKABLE DonationManager* donationManager() const { return m_donationManager.get(); }
    Q_INVOKABLE AppointmentManager* appointmentManager() const { return m_appointmentManager.get(); }

    Q_INVOKABLE bool backupDatabase(const QString& backupPath);
    Q_INVOKABLE bool isDatabaseConnected() const;
    Q_INVOKABLE QString getLastError() const;

private:
    QSqlDatabase m_database;
    std::unique_ptr<UserManager> m_userManager;
    std::unique_ptr<HospitalManager> m_hospitalManager;
    std::unique_ptr<DonationManager> m_donationManager;
    std::unique_ptr<AppointmentManager> m_appointmentManager;

    bool createTables();
    void setupConnections();
    QString m_lastError;
};
