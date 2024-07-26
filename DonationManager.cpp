#include "DonationManager.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDateTime>

Q_LOGGING_CATEGORY(donationManager, "database.donation")

DonationManager::DonationManager(QSqlDatabase& db, QObject *parent)
    : QObject(parent), m_db(db)
{
}

bool DonationManager::recordDonation(const QString &userEmail, double bloodAmount)
{
    QSqlQuery query(m_db);
    query.prepare("INSERT INTO blood_donations (user_id, donation_date, blood_amount) "
                  "SELECT id, :donation_date, :blood_amount FROM users WHERE email = :email");
    query.bindValue(":email", userEmail);
    query.bindValue(":donation_date", QDateTime::currentDateTime());
    query.bindValue(":blood_amount", bloodAmount);

    if (query.exec()) {
        qCInfo(donationManager) << "Donation record inserted successfully";
        return true;
    } else {
        qCCritical(donationManager) << "Error inserting donation record:" << query.lastError().text();
        return false;
    }
}

QVariantList DonationManager::getUserDonationHistory(const QString &userEmail)
{
    QVariantList donationHistory;
    QSqlQuery query(m_db);
    query.prepare("SELECT donation_date, blood_amount FROM blood_donations "
                  "JOIN users ON blood_donations.user_id = users.id "
                  "WHERE users.email = :email ORDER BY donation_date DESC");
    query.bindValue(":email", userEmail);

    if (query.exec()) {
        while (query.next()) {
            QVariantMap donation;
            donation["date"] = query.value("donation_date").toDateTime();
            donation["amount"] = query.value("blood_amount").toDouble();
            donationHistory.append(donation);
        }
    } else {
        qCCritical(donationManager) << "Error fetching donation history:" << query.lastError().text();
    }

    return donationHistory;
}

QVariantList DonationManager::getRecentDonations(int limit)
{
    QVariantList recentDonations;
    QSqlQuery query(m_db);
    query.prepare("SELECT u.name, u.blood_group, bd.donation_date, bd.blood_amount "
                  "FROM blood_donations bd "
                  "JOIN users u ON bd.user_id = u.id "
                  "ORDER BY bd.donation_date DESC LIMIT :limit");
    query.bindValue(":limit", limit);

    if (query.exec()) {
        while (query.next()) {
            QVariantMap donation;
            donation["name"] = query.value("name").toString();
            donation["bloodGroup"] = query.value("blood_group").toString();
            donation["date"] = query.value("donation_date").toDateTime();
            donation["amount"] = query.value("blood_amount").toDouble();
            recentDonations.append(donation);
        }
    } else {
        qCCritical(donationManager) << "Error fetching recent donations:" << query.lastError().text();
    }

    return recentDonations;
}

QVariantMap DonationManager::getBloodInventory()
{
    QVariantMap inventory;
    QSqlQuery query(m_db);
    query.prepare("SELECT u.blood_group, SUM(bd.blood_amount) as total_amount "
                  "FROM blood_donations bd "
                  "JOIN users u ON bd.user_id = u.id "
                  "GROUP BY u.blood_group");

    if (query.exec()) {
        while (query.next()) {
            QString bloodGroup = query.value("blood_group").toString();
            double totalAmount = query.value("total_amount").toDouble();
            inventory[bloodGroup] = totalAmount;
        }
    } else {
        qCCritical(donationManager) << "Error fetching blood inventory:" << query.lastError().text();
    }

    return inventory;
}

QVariantList DonationManager::getDetailedDonationHistory(const QString &userEmail)
{
    QVariantList detailedHistory;
    QSqlQuery query(m_db);
    query.prepare("SELECT bd.donation_date, bd.blood_amount, h.name as hospital_name "
                  "FROM blood_donations bd "
                  "JOIN users u ON bd.user_id = u.id "
                  "JOIN appointments a ON a.user_id = u.id AND a.appointment_date = bd.donation_date "
                  "JOIN hospitals h ON a.hospital_id = h.id "
                  "WHERE u.email = :email "
                  "ORDER BY bd.donation_date DESC");
    query.bindValue(":email", userEmail);

    if (query.exec()) {
        while (query.next()) {
            QVariantMap donation;
            donation["date"] = query.value("donation_date").toDateTime();
            donation["amount"] = query.value("blood_amount").toDouble();
            donation["hospitalName"] = query.value("hospital_name").toString();
            detailedHistory.append(donation);
        }
    } else {
        qCCritical(donationManager) << "Error fetching detailed donation history:" << query.lastError().text();
    }

    return detailedHistory;
}
