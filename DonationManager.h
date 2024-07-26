#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QVariantMap>
#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(donationManager)

class DonationManager : public QObject
{
    Q_OBJECT

public:
    explicit DonationManager(QSqlDatabase& db, QObject *parent = nullptr);

    Q_INVOKABLE bool recordDonation(const QString &userEmail, double bloodAmount);
    Q_INVOKABLE QVariantList getUserDonationHistory(const QString &userEmail);
    Q_INVOKABLE QVariantList getRecentDonations(int limit);
    Q_INVOKABLE QVariantMap getBloodInventory();
    Q_INVOKABLE QVariantList getDetailedDonationHistory(const QString &userEmail);

private:
    QSqlDatabase& m_db;
};
